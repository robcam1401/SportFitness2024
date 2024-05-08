import 'package:exercise_app/groupcircle.dart';
import 'package:exercise_app/square.dart';
import 'package:flutter/material.dart';
import 'package:exercise_app/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Friends extends StatefulWidget{
  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends> {
  // account variables
  String UserID = '';
  int friendRequestsCount = 0;

  @override
  void initState() {
    super.initState();
    getUserInfo(); // Get current user's ID when widget initializes
    getFriendRequestsCount(); // Retrieve friend requests count
  }

  void getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserID = prefs.getString("UserID") ?? '';
      print("User: $UserID");
    });
  }

  void getFriendRequestsCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString("UserID") ?? '';

    if (userID.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("Notifications")
            .where("Owner", isEqualTo: userID)
            .get();
        
        setState(() {
          friendRequestsCount = querySnapshot.size;
          print("Friend Requests Count: $friendRequestsCount");
        });
      } catch (e) {
        // Handle Firestore query error
        debugPrint("Error fetching friend requests count: $e");
      }
    }
  }

  // creates the list of widgets that populate the friends list
  Future<List<Widget>> addPeople() async {
    dynamic db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserID = prefs.getString("UserID")!;
    List<Widget> _widgets = [];
    // find the pairs of friends where the active user is user2 and create the widgets
    await db.collection("Friends").where("User2ID", isEqualTo: UserID).where("User1Accepted", isEqualTo: 'true').where("User2Accepted", isEqualTo: "true").get().then(
      (querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          Map friend = doc.data() as Map<String, dynamic>;
          // grab the user info of the friend
          await db.collection("UserAccount").doc(friend["User1ID"]).get().then(
            (DocumentSnapshot doc2) {
              Map user = doc2.data() as Map<String, dynamic>;
              _widgets.add(MySquare(username: user["Username"],friendID: friend["User1ID"], profilePicture: user["ProfilePicture"],UserID : UserID, pairID : doc.id, posterID: friend["User1ID"]));
            }
          );
        }
      }
    );
    // grab the pair info where the current user is user1
    await db.collection("Friends").where("User1ID", isEqualTo: UserID).where("User1Accepted", isEqualTo: "true").where("User2Accepted", isEqualTo : 'true').get().then(
      (querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          Map friend = doc.data() as Map<String, dynamic>;
          await db.collection("UserAccount").doc(friend["User2ID"]).get().then(
            (DocumentSnapshot doc2) {
              Map user = doc2.data() as Map<String, dynamic>;
              _widgets.add(MySquare(username: user["Username"],friendID: friend["User2ID"], profilePicture: user["ProfilePicture"], UserID: UserID, pairID : doc.id,posterID: friend["User2ID"]));
            }
          );
        }
        return _widgets;
      }
    );
    
    return _widgets;
  }
  
  // same logic as the addPeople, just with groupID and no user1/2
  Future<List<Widget>> addGroups() async {
      dynamic db = FirebaseFirestore.instance;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserID = prefs.getString("UserID")!;
      List<Widget> _widgets = [];
      await db.collection("GroupMembers").where("UserID", isEqualTo: UserID).get().then(
        (querySnapshot) async {
          for (var doc in querySnapshot.docs) {
            Map member = doc.data() as Map<String, dynamic>;
            await db.collection("Groups").doc(member["GroupID"]).get().then(
              (DocumentSnapshot doc2) {
                Map group = doc2.data() as Map<String, dynamic>;
                 _widgets.add(MyCircle(name: group["Name"], groupPicture: group["GroupPicture"],UserID: UserID, groupID: member["GroupID"],));
              }
            );
           
          }
        }
      );
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notifications()),
              );
            },
            icon: Icon(Icons.person_add),
          ),
          if (friendRequestsCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.girl), // Use any icon you prefer
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        friendRequestsCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: 
      Column(
        children: [
          // future builder for the friends
          FutureBuilder(
            future: addPeople(),
            builder: ((BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done){
                if (snapshot.hasData) {
                  List<Widget> _widgets = snapshot.data;
                  if (!_widgets.isEmpty) {
                    return Expanded(
                      flex: 80,
                      child: ListView(
                        children: _widgets
                      )
                    );
                  }
                  else {
                    return const Expanded(child: Center(child: Text("No friends? :(")));
                  }
                }
                else {
                  return Text("Loading Friends");
                }
              }
              else {
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              }
            })
          ),
          // future builder for the groups
          FutureBuilder<dynamic>(
            future: addGroups(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
              if (snapshot.connectionState == ConnectionState.done){
                if (snapshot.hasData) {
                  List<Widget> _widgets = snapshot.data;
                  if (!_widgets.isEmpty) {
                    return Expanded(
                      flex: 20,
                      child: Container(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _widgets
                        )
                      )
                    );
                  }
                  else {
                    return const Expanded(child: Center(child: Text("No Groups? :(")));
                  }
                }
                else {
                  return Text("Groups Loading");
                }
              }
              else {
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              }
            }
          ),
        ],
      ),

    );
  }

}
