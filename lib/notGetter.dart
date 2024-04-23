import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class GetUserNotifications extends StatelessWidget{
  final String documentIds;

  GetUserNotifications({required this.documentIds});
  @override

  Widget build(BuildContext context){
    CollectionReference Notifications = FirebaseFirestore.instance.collection("Notifications");




    return FutureBuilder<DocumentSnapshot>(
      future: Notifications.doc(documentIds).get(),
      builder: ((context, snapshot){
      if(snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data = 
          snapshot.data!.data() as Map<String,dynamic>;
          return Text('Time: ${data['Time'].toDate()}');
      }
      return Text('loading...');
    }));
  }
}


