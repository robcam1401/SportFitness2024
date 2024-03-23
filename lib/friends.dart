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
  // sample data for the list
  //  will be updated with data in the database later
  static List _locals = Insert().test_friends();
  final List _people = _locals[0];
  final List _pairs = _locals[1];
  var test = Insert().test_string();
  // this query returns a list of lists
  // the _people list contains usernames of friends
  // the _pairs list contains pair IDs of friends

  final List _groups = [
    'nabinta',
    'cam',
    'zach',
    'olga',
    'person 5',
    '1',
    '2',
    '3',
    '4',
  ];
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
          Expanded(
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
             
            ),
          Expanded(
            flex: 80,
            child: Container(
            child: ListView.builder(
                itemCount: _people.length,
                itemBuilder: (context, index) {
                  return MySquare(
                    child: _people[index],
                  );
                }
            ),
            )
          )
        ],
      )
    
    );
  }
}

