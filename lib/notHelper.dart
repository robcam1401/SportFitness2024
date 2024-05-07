import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/chat.dart';
import 'package:exercise_app/other_profile.dart';
import 'package:exercise_app/settings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';





class NotificationsBlock extends StatefulWidget{

@override
_NotificationsBlock createState() => _NotificationsBlock();
final String child;

NotificationsBlock({required this.child});
}

class _NotificationsBlock extends State<NotificationsBlock> {


  String user = "";

getNotification(id ,type) async {
  await FirebaseFirestore.instance.collection("UserAccount").where(FieldPath.documentId ,isEqualTo: id).get().then(
    (snapshot) => snapshot.docs.forEach(
      (document) {
        user = (document["Username"] + " sent a "+ type);
      },
    ),
      );
}

acceptfriend(owner, sender) async {
  dynamic db = FirebaseFirestore.instance.collection("Friends"); 
  print(sender + owner);
      await db.doc(sender + owner).update({"User2Accepted": "true"}); 

}

readTime(timestamp)  {
  String time = "";
    var now = DateTime.now();
  DateTime dt = (timestamp['Time'] as Timestamp).toDate();

  var diff = now.difference(dt);
  var formated = DateFormat(" HH:MM a");

  if( diff.inDays ==0) {
    time = formated.format(dt);
  }
  else if (diff.inDays == 1){
    time = diff.inDays.toString() + " Day Ago";
  }
  else{
    time = diff.inDays.toString() + " Days Ago";
  }


  return time ;
}







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
                // height: 75,
                // padding: EdgeInsets.all(5),
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                    child: ListView(
                    padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    ),
                    shrinkWrap: true,
                    children: <Widget>[
                    InkWell(
                      onTap: () {
                        dynamic db = FirebaseFirestore.instance;
                        db.collection("Notifications").doc(widget.child).get().then(
                        (DocumentSnapshot doc) {
                          Map data = doc.data() as Map<String, dynamic>;
                          String sender = data["Sender"];
                          String owner = data["Owner"];
                          acceptfriend(owner, sender);                        
                          db.collection("Notifications").doc(widget.child).delete();

                        },
                      );
                    },
                    child: Container(
                    height: 50,
                    child: const Center (child: Text('Add Friend'))
                    ),
                    ),
                    InkWell(
                    onTap: () {
                        dynamic db = FirebaseFirestore.instance;
                          db.collection("Notifications").doc(widget.child).delete();
                    },
                    child: Container(
                    height: 50,
                    child: const Center (child: Text('Delete'))
                    ),
                    )
                                
                    ]
                    ),
                    ),
                    );
                  ;},
                child: Align(alignment: Alignment.centerLeft,
                  child: 
                    FutureBuilder<DocumentSnapshot>(
                      future: Notifications.doc(widget.child).get(),
                      builder: ((context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = 
                          snapshot.data!.data() as Map<String,dynamic>;
                          return FutureBuilder(
                          future: getNotification(data["Sender"],data["Type"]) , 
                          builder: (context, snapshot){
                            return  Text("$user");
                        }
                        );
                      }
                      return Text('loading...');
                    })) , 
                    
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
                      future: Notifications.doc(widget.child).get(),
                      builder: ((context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = 
                          snapshot.data!.data() as Map<String,dynamic>;
                          String time = readTime(data);
                          
                 
                          return Text(time);
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