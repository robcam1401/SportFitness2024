import 'package:exercise_app/square.dart';
import 'package:flutter/material.dart';



class Groups extends StatefulWidget{
  @override
  State<Groups> createState() => _Groups();
}

class _Groups extends State<Groups> {
// sample data for the list
  //  will be updated with data in the database later
  // group membership json from the server will be formatted as:
  // {"communities" : [{"commID" : <>}, {...}]}
  // once connection works:
  // static String sentString = Query().account_communities(1);
  // static dynamic sentData = jsonDecode(sentString);
  // final List _communities = sentData["communities"];
  // final List _people = [_communities[0]["commID"],_communities[1]["commID"]]
  final List _people = [
    'workout 1',
    'workout 2',
    'latech gym',
    'football tech',
    'intramural team 6',
    
  ];
  @override
// made an appbar to label the screen
// followed by the list that is created with LiastView.builder
// the list is populated by the custom class in the file 'square.dart'
// this allows for the code to be condensed and allow for easy managment
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
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
