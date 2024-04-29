import 'package:flutter/material.dart';



class Groups extends StatefulWidget{
  @override
  State<Groups> createState() => _Groups();
}

class _Groups extends State<Groups> {
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
            child: Container(),
            // child: ListView.builder(
            //     itemCount: _people.length,
            //     itemBuilder: (context, index) {
            //       return MySquare(
            //         username: _people[index],
            //         profilePicture: "group pic",
            //         UserID: "",
            //         pairID: ""
            //       );
            //     }
            // ),
          ),
        ],
      )
    
    );
  }
}

