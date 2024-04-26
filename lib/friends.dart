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
  List<String> _friends = [];
  List<String> _pfps = [];
  List<String> _pairs = [];

  // void initState() {
  //   super.initState();
  //   getUserInfo();
  // }

  void getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserID = prefs.getString("UserID")!;
  }

  Future<List<Widget>> addPeople() async {
    dynamic db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserID = prefs.getString("UserID")!;
    String loading = "Loading";
    List<Widget> _widgets = [];
    await db.collection("Friends").where("User2ID", isEqualTo: UserID).where("User2Accepted", isEqualTo: "true").get().then(
      (querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          Map friend = doc.data() as Map<String, dynamic>;
          await db.collection("UserAccount").doc(friend["User1ID"]).get().then(
            (DocumentSnapshot doc2) {
              loading = "Completed";
              Map user = doc2.data() as Map<String, dynamic>;
              _widgets.add(MySquare(username: user["Username"], profilePicture: user["ProfilePicture"],UserID : UserID, pairID : doc.id, posterID: friend["User1ID"]));
            }
          );
        }
      }
    );
    await db.collection("Friends").where("User1ID", isEqualTo: UserID).where("User1Accepted", isEqualTo: "true").get().then(
      (querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          Map friend = doc.data() as Map<String, dynamic>;
          await db.collection("UserAccount").doc(friend["User2ID"]).get().then(
            (DocumentSnapshot doc2) {
              loading = "Completed";
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
  // sample data for the list
  //  will be updated with data in the database later
  // final List _people = _locals['_people'];
  // final List _pairs = _locals['_pairs'];

  // this query returns a list of lists
  // the _people list contains usernames of friends
  // the _pairs list contains pair IDs of friends

  // final List _people = [
  //   'nabinta',
  //   'cam',
  //   'zach',
  //   'olga',
  //   'person 5',
  //   user1,
  // ];

  // final List _groups = [
  //   'nabinta',
  //   'cam',
  //   'zach',
  //   'olga',
  //   'person 5',
  //   '1',
  //   '2',
  //   '3',
  //   '4',
  // ];
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