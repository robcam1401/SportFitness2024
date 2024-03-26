import 'dart:convert';
import 'package:exercise_app/groupcircle.dart';
import 'package:exercise_app/square.dart';
import 'package:exercise_app/groupcircle.dart';
import 'package:flutter/material.dart';
import 'dbInterface.dart';

class Friends extends StatefulWidget{
  @override
  State<Friends> createState() => _Friends();
  Future<Map> _locals = Query().friends_list(4);
}

class _Friends extends State<Friends> {
  final Future<Map> _locals = Query().friends_list(4);
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
          // I really don't know how this works, hopefully it works perfectly
          FutureBuilder<Map>(
            future: _locals, 
            builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  // if (!snapshot.hasData){
                  //   return Text('No Data');
                  // }
                // once the data is loaded, separate it into the two lists
                // and build the list widget
                  final _people = snapshot.data?['_people'];
                  final _pairs = snapshot.data?['_pairs'];
                  if (_people.length == 0) {
                    return Text('No Friends? :( ');
                  }
                  else {
                    return Expanded(
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
                default:
                  List _people = [];
                  List _pairs = [];
                  return Expanded(
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

          ),
          // Expanded(
          //   child: ListView.builder(
          //       itemCount: _people.length,
          //       itemBuilder: (context, index) {
          //         return MySquare(
          //           child: _people[index],
          //         );
          //       }
          //   ),
          // ),
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
      ),

    );
  }

}