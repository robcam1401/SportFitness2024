import 'package:exercise_app/square.dart';
import 'package:flutter/material.dart';
import 'dbInterface.dart';

class Friends extends StatefulWidget{
  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends> {
  // sample data for the list
  //  will be updated with data in the database later
  static final Map _locals = Query().friends_list(1);
  final List _people = _locals['_people'];
  final List _pairs = _locals['_pairs'];
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
            child: ListView.builder(
                itemCount: _people.length,
                itemBuilder: (context, index) {
                  return MySquare(
                    child: _people[index],
                  );
                }
            ),
          ),
        ],
      )
    
    );
  }
}

