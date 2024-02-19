import 'package:exercise_app/chat.dart';
import 'package:exercise_app/other_profile.dart';
import 'package:exercise_app/settings.dart';
import 'package:flutter/material.dart';



class MyPost extends StatelessWidget{
final String child;

MyPost({required this.child});
//creates the format for the list boxes and circleavatar widgets used 
//in the freind list and group list
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: InkWell(
                child: Container(
                  height: 400,
                  padding: EdgeInsets.all(5),
                  child: Align(alignment: Alignment.center,
                    child: Text(
                      child, 
                      style: TextStyle(fontSize: 15)),
                      ),
                ),
              ),
            ),
          ),
           
        ],
      ),
    );
  }
}