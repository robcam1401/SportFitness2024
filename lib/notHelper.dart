// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/chat.dart';
import 'package:exercise_app/other_profile.dart';
import 'package:exercise_app/settings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


class NotificationsBlock extends StatefulWidget {
  final String child;

  NotificationsBlock({required this.child});

  @override
  _NotificationsBlockState createState() => _NotificationsBlockState();
}

class _NotificationsBlockState extends State<NotificationsBlock> {
  late Future<Map<String, String>> _userFuture; // Future to hold user data

  @override
  void initState() {
    super.initState();
    _userFuture = _getNotificationData(); // Initialize the user data future
  }

  Future<Map<String, String>> _getNotificationData() async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Notifications")
        .doc(widget.child)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      String senderId = data["Sender"];

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("UserAccount")
          .doc(senderId)
          .get();

      if (userSnapshot.exists) {
        String senderUsername = userSnapshot["Username"];
        String profilePicture = userSnapshot["ProfilePicture"];
        return {
          'username': senderUsername,
          'profilePicture': profilePicture,
        };
      }
    }

    return {}; // Return an empty map if data retrieval fails
  } catch (e) {
    print("Error fetching notification data: $e");
    return {}; // Return an empty map on failure
  }
}



  Future<void> acceptFriend(String owner, String sender) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("Friends")
        .doc(sender + owner);

    await docRef.update({"User2Accepted": "true"});

    // Remove notification after friend request accepted
    await FirebaseFirestore.instance
        .collection("Notifications")
        .doc(widget.child)
        .delete();
  }

  String readTime(Timestamp timestamp) {
    DateTime dt = timestamp.toDate();
    var diff = DateTime.now().difference(dt);
    if (diff.inDays == 0) {
      return DateFormat("HH:mm a").format(dt);
    } else if (diff.inDays == 1) {
      return "${diff.inDays} Day Ago";
    } else {
      return "${diff.inDays} Days Ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 80,
            child: FutureBuilder<Map<String, String>>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    String senderUsername = snapshot.data!['username']!;
                    String profilePicture = snapshot.data!['profilePicture']!;

                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(profilePicture),
                          radius: 20,
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: senderUsername,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('User data not available');
                  }
                }
                return Text('Loading...');
              },
            ),
          ),
          Expanded(
            flex: 30,
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("Notifications")
                  .doc(widget.child)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  String time = readTime(data['Time']);
                  return Text(time);
                }
                return Text('Loading...');
              },
            ),
          ),
          NotificationActions(
            widget.child,
            acceptCallback: acceptFriend,
          ),
        ],
      ),
    );
  }
}

class NotificationActions extends StatelessWidget {
  final String notificationId;
  final Function(String, String) acceptCallback;

  NotificationActions(this.notificationId, {required this.acceptCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            FirebaseFirestore.instance
                .collection("Notifications")
                .doc(notificationId)
                .get()
                .then((DocumentSnapshot doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              String sender = data["Sender"];
              String owner = data["Owner"];
              acceptCallback(owner, sender);
            });
          },
          child: Container(
            height: 50,
            width: 50,
            child: const Center(child: Icon(Icons.done)), // Tick icon for accepting
          ),
        ),
        SizedBox(width: 3),
        InkWell(
          onTap: () {
            FirebaseFirestore.instance
                .collection("Notifications")
                .doc(notificationId)
                .delete();
          },
          child: Container(
            height: 50,
            width: 50,
            child: const Center(child: Icon(Icons.close)), // X icon for declining
          ),
        ),
      ],
    );
  }
}
