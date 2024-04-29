import 'package:exercise_app/notGetter.dart';
import 'package:exercise_app/notHelper.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'faq_page.dart';
import 'package:exercise_app/loginScreen.dart';
import 'package:flutter/material.dart';
import 'profile_settings.dart';
import 'account_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// String encodeQueryParameters(Map<String, String> params) {
//   return params.entries
//       .map((e) =>
//           '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
//       .join('&');
// }

class Notifications extends StatelessWidget {
  @override
  List<String> docIDs = [];

  getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.get('UserID').toString();
    await FirebaseFirestore.instance
        .collection("Notifications")
        .where("Owner", isEqualTo: id)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getId(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: docIDs.length,
                      itemBuilder: (context, index) {
                        return NotificationsBlock(
                          child: docIDs[index],
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Notifications(),
//   ));
// }
