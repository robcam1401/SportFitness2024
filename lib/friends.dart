import 'package:exercise_app/square.dart';
import 'package:flutter/material.dart';
import 'dbInterface.dart';
import 'dart:convert';

class Friends extends StatefulWidget{
  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends> {
  // sample data for the list
  //  will be updated with data in the database later
  // These jsons are json strings sent from the sql server
  // connecting to server is finnicky, so jsons are hard-coded for now
  static const json = '{"friends" : [{"pairID" : "1", "acctNum" : "2"}, {"pairID" : "2", "acctNum" : "3"}]}';
  static const json2 = '{"friends": [{"pairID": 1, "acctNum": 2}, {"pairID": 2, "acctNum": 3}], "usernames": [{"acctNum": 2, "username": "GenericUser"}, {"acctNum": 3, "username": "GenericUser2"}]}';
  // these are for actually connecting to the server

  //static dynamic sentString = Query().friends_list(1);
  //static dynamic sentData = jsonDecode(sentString);
  static dynamic jsonData = jsonDecode(json);
  static dynamic json2Data = jsonDecode(json2);
  // jsonFriends contains pair ids associated with friend pairs
  // jsonAccounts contains usernames associated with accounts in the pairs
  static dynamic jsonFriends = json2Data["friends"];
  static dynamic jsonAccounts = json2Data["usernames"];
  // _pairs will be used to open a chat for a specific friend pair
  // _people contains the list of usernames associated with pairs
  final List _pairs = [jsonFriends[0]["pairID"], jsonFriends[1]["pairID"]];
  final List _people = [jsonAccounts[0]["username"], jsonAccounts[1]["username"]];
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

