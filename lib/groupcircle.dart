import 'package:exercise_app/chat.dart';
import 'package:exercise_app/other_profile.dart';
import 'package:exercise_app/settings.dart';
import 'package:flutter/material.dart';



class MyCircle extends StatelessWidget{
final String child;

MyCircle({required this.child});
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
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen())); },
                child: const CircleAvatar(backgroundImage:NetworkImage('assets/train.jpg'),
                radius: 60,
                
                ),
              )
              ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Text(child,
              style: TextStyle(fontSize: 15)),
            )

          ),
          
           
        ],
      ),
    );
  }
}