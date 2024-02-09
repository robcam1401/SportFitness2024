import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: ChatScreen()
));




class ChatScreen extends StatelessWidget{
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

