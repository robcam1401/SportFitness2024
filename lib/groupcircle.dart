import 'package:exercise_app/chat.dart';
import 'package:flutter/material.dart';



class MyCircle extends StatelessWidget{
final String name;
final String groupPicture;
final String UserID;
final String groupID;

MyCircle({required this.name, required this.groupPicture, required this.UserID, required this.groupID});
//creates the format for the list boxes and circleavatar widgets used 
//in the freind list and group list
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            flex:10,
            child: Container(
              width: 60,
              child: InkWell(
                onTap: () {
                  // pushes an instance of other profile onto the navigator stack when the pfp is clicked
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(UserID: UserID, pairID: groupID, username: name, profilePicture: groupPicture, friends: false))); },
                child: CircleAvatar(backgroundImage:NetworkImage(groupPicture),
                radius: 60,
                ),
              )
              ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Text(name,
              style: TextStyle(fontSize: 20)),
            )

          ),
          
           
        ],
      ),
    );
  }
}