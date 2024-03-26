import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'dbInterface.dart';

class ChatScreen extends StatefulWidget{
  @override
  State<ChatScreen> createState() => _Chatscreen();
}

class _Chatscreen extends State<ChatScreen> {
  // account variables
  int _account_number = 1;
  int _pair_id = 1;

  // future functions
  Future<List<Widget>> addMessages(_pair_id, _account_number) async {
    Map _locals_messages = await Query().friend_messages(_pair_id, _account_number);
    List<Widget> children = _locals_messages['children'];
    print("here $_locals_messages");
    return children;
  }

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
        FutureBuilder<List<Widget>>(
          future: addMessages(_pair_id, _account_number),
          builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot){
            if (snapshot.connectionState == ConnectionState.done){
              final _messages = snapshot.data;
              int _mList_length = _messages!.length; 
              List _children = _messages;
              if (_mList_length == 0) {
                return Text("No Messages? :( ");
              }
              else {
                Widget child = SingleChildScrollView(
                  child: Column (
                    children: _messages
                  )
                );
                return child;
              }
            }
            else if (snapshot.hasError) {
                return Text("Snapshot Error");
              }
              return const CircularProgressIndicator();
          }
        ),
        // const SingleChildScrollView(
        //   child: Column(
        //     children: <Widget>[
        //         BubbleSpecialThree(
        //         text: "bubble special three with tail",
        //         color: Color(0xFFE8E8EE),
        //         tail: true,
        //         isSender: true,
        //       ),
              
        //       BubbleSpecialThree(
        //         text: "bubble special three with tail",
        //         color: Color(0xFFE8E8EE),
        //         tail: true,
        //         isSender: false,
        //       ),
        //       SizedBox(
        //         height: 100,
        //       )
        //     ],
        //   ),
        // ),
        MessageBar(
          onSend: (_) => Insert().new_friend_messages({"PairID" : _pair_id, "MessageBody" : _, "SentUser" : _account_number}),
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