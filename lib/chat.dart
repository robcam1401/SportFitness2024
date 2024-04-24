import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dbInterface.dart';

class ChatScreen extends StatefulWidget{
  final String pairID;
  final String UserID;
  final String username;
  final String profilePicture;

  const ChatScreen({Key? key, required this.pairID, required this.UserID, required this.username, required this.profilePicture})
      : super(key: key);


  @override
  State<ChatScreen> createState() => _Chatscreen();
}

class _Chatscreen extends State<ChatScreen> {

  // future functions
  Future<List<Widget>> addMessages() async {
    dynamic db = FirebaseFirestore.instance;
    List<Widget> _messages = [];
    await db.collection("FriendMessages").where("PairID", isEqualTo: widget.pairID).orderBy("SentStamp").get().then(
      (querySnapshot) {
        int length = querySnapshot.docs.length;
        for (var doc in querySnapshot.docs) {
          Map message = doc.data() as Map<String, dynamic>;
          bool sent = false;
          bool last = false;
          if (message["SentUser"] == widget.UserID) {
            sent = true;
          }
          else {
            sent = false;
          }
          if (length == 1) {
            last = true;
          }
          Widget bs = BubbleSpecialThree(
                text: message["MessageBody"],
                color: sent ? Color.fromARGB(255, 192, 192, 252) : Color(0xFFE8E8EE),
                tail: last,
                isSender: sent,
          );
          _messages.add(bs);  
          length = length - 1;
        }
      }
    );

    return _messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.username),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        actions: [CircleAvatar(backgroundImage: NetworkImage(widget.profilePicture))],
      ),
      body: Stack(
      children: [
        FutureBuilder(
          future: addMessages(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.connectionState == ConnectionState.done){
              if (snapshot.hasData) {
                // the messages don't update when inserted, so maybe create a ChangeNotifier Listener for the
                // messages list to auto update when inserted 
                return SingleChildScrollView(
                  child: Column (
                    children: snapshot.data
                  )
                );
              }
            }
            else if (snapshot.hasError) {
                return Text("Snapshot Error");
              }
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator()
                  ));
          }
        ),
        MessageBar(
          onSend: (_) => {
            FirebaseFirestore.instance.collection("FriendMessages").add(
              {
                "MessageBody" : _, 
              "PairID" : widget.pairID, 
              "SentUser" : widget.UserID, 
              "SentStamp" : DateTime.timestamp()
              }
              ), setState(() {})},
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