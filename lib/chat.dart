import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget{
  @override
  State<ChatScreen> createState() => _Chatscreen();
}

class _Chatscreen extends State<ChatScreen> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text("message send to"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        actions: [const CircleAvatar()],
      ),
      body: Stack(
      children: [
        const SingleChildScrollView(
          child: Column(
            children: <Widget>[
                BubbleSpecialThree(
                text: "bubble special three with tail",
                color: Color(0xFFE8E8EE),
                tail: true,
                isSender: true,
              ),
              
              BubbleSpecialThree(
                text: "bubble special three with tail",
                color: Color(0xFFE8E8EE),
                tail: true,
                isSender: false,
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
        MessageBar(
          onSend: (_) => print(_),
          actions: [
            InkWell(
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 24,
              ),
              onTap: () {},
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: InkWell(
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.green,
                  size: 24,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    ),
    // This trailing comma makes auto-formatting nicer for build methods.
  );
}
}