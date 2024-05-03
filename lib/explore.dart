import 'package:exercise_app/other_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/display_profile.dart';

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

class Explore extends StatefulWidget {
  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      _userService.searchUsers(query).then((results) {
        setState(() {
          _searchResults = results;
        });
      }).catchError((error) {
        print('Error searching users: $error');
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
                hintText: 'Search by username...',
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

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> userData = _searchResults[index];
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
      },
    );
  }
}
