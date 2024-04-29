import 'package:exercise_app/groupcircle.dart';
import 'package:exercise_app/square.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Friends extends StatefulWidget{
  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends> {
  // account variables
  String UserID = '';

  // void initState() {
  //   super.initState();
  //   getUserInfo();
  // }

  void getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserID = prefs.getString("UserID")!;
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
              _widgets.add(MySquare(username: user["Username"], profilePicture: user["ProfilePicture"],UserID : UserID, pairID : doc.id, posterID: friend["User1ID"]));
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
              _widgets.add(MySquare(username: user["Username"], profilePicture: user["ProfilePicture"], UserID: UserID, pairID : doc.id,posterID: friend["User2ID"]));
            }
          );
        }
        return _widgets;
      }
    );
    
    return _widgets;
  }
  // Future<dynamic> addPeople2(friendPair) {
  //   dynamic db = FirebaseFirestore.instance;


  // }

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
// made an appbar to label the screen
// followed by the list that is created with LiastView.builder
// the list is populated by the custom class in the file 'square.dart'
// this allows for the code to be condensed and allow for easy managment
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        centerTitle: true,
        backgroundColor: Colors.red,
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