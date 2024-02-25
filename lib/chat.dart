import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: ChatScreen()
));




class ChatScreen extends StatelessWidget{
  // chat message data sent from server will be formatted as:
  // {"messages" : [list]}
  // where the list contains json objects of the form:
  // {
  //    "pairID" : int,
  //    "messageID" : int,
  //    "message" : 'str',
  //    "timestamp" : str,
  //    "sentUser" : int
  // }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Friends'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
    );
  }
}

