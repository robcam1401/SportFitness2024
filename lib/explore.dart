import 'package:exercise_app/other_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/other_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    List<Map<String, dynamic>> results = [];

    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('UserAccount')
          .where('Username', isGreaterThanOrEqualTo: query)
          .where('Username', isLessThanOrEqualTo: query + '\uf8ff')
          .orderBy('Username')
          .get();

      userSnapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        userData['id'] = doc.id; // Add the document ID as 'id' in the userData map
        results.add(userData);
      });
    } catch (e) {
      print('Error searching users: $e');
    }

    return results;
  }
}

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Map<String,dynamic>>> searchGroups(String query) async {
    List<Map<String,dynamic>> results = [];

    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('Groups')
          .where('Name', isGreaterThanOrEqualTo: query)
          .where('Name', isLessThanOrEqualTo: query + '\uf8ff')
          .orderBy('Name')
          .get();

      userSnapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        userData['id'] = doc.id; // Add the document ID as 'id' in the userData map
        results.add(userData);
      });
    } catch (e) {
      print('Error searching users: $e');
    }

    return results;

  }
}

class Explore extends StatefulWidget {
  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final UserService _userService = UserService();
  final GroupService _groupService = GroupService();
  List<Map<String, dynamic>> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      List<Map<String,dynamic>> docsU = [];
      _userService.searchUsers(query).then((results) {
        setState(() async {
          // _searchResults = results;
          for (var doc in results) {
            doc["type"] = "U";
            docsU.add(doc);
          }
          _searchResults = _searchResults + docsU;
        });
      }).catchError((error) {
        print('Error searching users: $error');
      });
      List<Map<String,dynamic>> docsG = [];
      _groupService.searchGroups(query).then((results) {
        setState(() {
          print(results);
          for (var doc in results) {
            doc["type"] = "G";
            docsG.add(doc);
          }
          _searchResults = _searchResults + docsG;
        }
        );
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                ),
              ),
              onChanged: _performSearch,
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No users found.'),
      );
    }
    List searchResults = _searchResults;
    _searchResults = [];
    bool isAdded = false;
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> userData = searchResults[index];
        if (userData["type"] == 'U') {  
          if (!userData["Private"]) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userData['ProfilePicture']),
            ),
            title: Text(userData['Username']),
            subtitle: Text(userData['FullName']),
            onTap: () {
              String userId = userData['id']; // Extract user ID from userData map
              print('UserID: $userId'); // Print userID before navigation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => otherProfile(posterID: userId),
                ),
              );
            },
          );
        }
        else {
          return Text("");
        }
        }
        else {
          print(userData);  
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userData['GroupPicture']),
            ),
            title: Text(userData['Name']),
            trailing: Icon(Icons.add_reaction_outlined, color: Colors.black),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String UserID = prefs.getString("UserID")!;
              String GroupID = userData['id'];
              print("$UserID, $GroupID");
              dynamic db = FirebaseFirestore.instance;
              db.collection("GroupMembers").add({"GroupID" : GroupID, "UserID" : UserID}); // Extract user ID from userData map
              setState(){
                isAdded = true;
              };
              
            },
          );
        }
      },
    );
  }
}
