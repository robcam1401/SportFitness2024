import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/chat.dart';
import 'package:exercise_app/other_profile.dart';
import 'package:exercise_app/settings.dart';
import 'package:flutter/material.dart';



class NotificationsBlock extends StatelessWidget{
final String child;

NotificationsBlock({required this.child});
//creates the format for the list boxes and circleavatar widgets used 
//in the freind list and group list.



  @override
  Widget build(BuildContext context) {
        CollectionReference Notifications = FirebaseFirestore.instance.collection("Notifications");

    return  Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          
          Expanded(
            flex:70,
            child: InkWell(
              child: Container(
                height: 75,
                padding: EdgeInsets.all(5),
                child: Align(alignment: Alignment.centerLeft,
                  child: 
                    FutureBuilder<DocumentSnapshot>(
                      future: Notifications.doc(child).get(),
                      builder: ((context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = 
                          snapshot.data!.data() as Map<String,dynamic>;
                          return Text('${data['Type']}');
                      }
                      return Text('loading...');
                    })) , 
                    
                    ),
              ),
            ),
          ),
          Expanded(
            flex:30,
            child: InkWell(
              child: Container(
                height: 75,
                padding: EdgeInsets.all(5),
                child: Align(alignment: Alignment.centerLeft,
                  child: 
                    FutureBuilder<DocumentSnapshot>(
                      future: Notifications.doc(child).get(),
                      builder: ((context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = 
                          snapshot.data!.data() as Map<String,dynamic>;
                          return Text('${data['Time'].toDate()}');
                      }
                      return Text('loading...');
                    })) , 
                    
                    ),
              ),
            ),
          ),
          
           
        ],
      ),
    );
  }
}