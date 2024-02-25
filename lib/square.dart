import 'package:exercise_app/chat.dart';
import 'package:exercise_app/other_profile.dart';
import 'package:exercise_app/settings.dart';
import 'package:flutter/material.dart';



class MySquare extends StatelessWidget{
final String child;

MySquare({required this.child});
//creates the format for the list boxes and circleavatar widgets used 
//in the freind list and group list
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex:10,
            child: Container(
              child: InkWell(
                onLongPress: () {Navigator.push(context, MaterialPageRoute(builder: (context) => otherProfile())); },
                child: const CircleAvatar(backgroundImage:NetworkImage('assets/train.jpg'),
                radius: 37.5,
                
                ),
              )
              ),
          ),
          Expanded(
            flex:90,
            child: InkWell(
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen())); },
              child: Container(
                height: 75,
                padding: EdgeInsets.all(5),
                child: Align(alignment: Alignment.centerLeft,
                  child: Text(
                    child, 
                    style: TextStyle(fontSize: 15)),
                    ),
              ),
            ),
          ),
           
        ],
      ),
    );
  }
}