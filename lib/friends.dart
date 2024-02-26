import 'package:exercise_app/square.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget{
  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends> {
  // sample data for the list
  //  will be updated with data in the database later
  final List _people = [
    'nabinta',
    'cam',
    'zach',
    'olga',
    'person 5',
    'person 6',
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

