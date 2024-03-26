import 'dart:convert';
import 'package:exercise_app/groupcircle.dart';
import 'package:exercise_app/square.dart';
import 'package:exercise_app/groupcircle.dart';
import 'package:flutter/material.dart';
import 'dbInterface.dart';

class Friends extends StatefulWidget{
  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends> {
  // account variables
  int _account_number = 1;

  Future<Map> addPeople() async {
    Map _locals_friends = await Query().friends_list(_account_number);
    return _locals_friends;
  }
  Future<Map> addGroups() async {
    Map _locals_groups = await Query().groups_list(_account_number);
    return _locals_groups;
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
          // I really don't know how this works, hopefully it works perfectly
          // future builder for the friends
          FutureBuilder<Map>(
            future: addPeople(), 
            builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
              if (snapshot.connectionState == ConnectionState.done){
                final _people = snapshot.data!['_people'];
                final _pairs = snapshot.data!['_pairs'];
                if (_people.length == 0) {
                  return const Text('No Friends? :( ');
                }
                else {
                  return Expanded(
                    flex: 80,
                    child: ListView.builder(
                      itemCount: _people.length,
                      itemBuilder: (context, index) {
                        return MySquare(
                          child: _people[index],
                        );
                      }
                    )
                  );
                }
              }
              else if (snapshot.hasError) {
                return Text("Snapshot Error");
              }
              return const CircularProgressIndicator();
            }
          ),
          // future builder for the groups
          FutureBuilder<Map>(
            future: addGroups(),
            builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
              if (snapshot.connectionState == ConnectionState.done){
                if (snapshot.hasData) {
                  final _groups = snapshot.data!['_groups'];
                  if (_groups.length == 0) {
                    return const Text('No Groups? :( ');
                  }
                  else {
                    return Expanded(
                      flex: 20,
                      child:Container(
                        child:  ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _groups.length,
                          itemBuilder: (context, index) {
                            return MyCircle(
                              child: _groups[index],
                            );
                          }
                        ),
                      )
                    );
                  }
                }
              }
              else if (snapshot.hasError) {
                return Text("Snapshot Error");
              }
              return const CircularProgressIndicator();
            }
          ),
        ],
      ),

    );
  }

}