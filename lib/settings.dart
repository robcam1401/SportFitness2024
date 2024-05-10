import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/WelcomeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'faq_page.dart';
import 'package:exercise_app/loginScreen.dart';
import 'package:flutter/material.dart';
import 'profile_settings.dart';
import 'account_settings.dart';
import 'package:url_launcher/url_launcher.dart';

String encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Profile Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSettingsPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Account Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountSettingsPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Notification Settings'),
            onTap: () {
              // Navigate to notification settings page
            },
          ),
          ListTile(
            title: Text('Privacy Settings'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  dynamic db = FirebaseFirestore.instance;
                  bool isPrivate = false; // Default value for the switch
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text('Privacy Settings'),
                        content: SingleChildScrollView(
                          // If content doesn't fit the screen
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                "When your account is private, only the followers you approve can see what you share and your followers and following lists.",
                              ),
                              SwitchListTile(
                                title: Text('Private Account'),
                                value: isPrivate,
                                onChanged: (bool value) {
                                  setState(() {
                                    isPrivate = value;
                                    dynamic db = FirebaseFirestore.instance;
                                    db.collection("UserAccount").update({"Private" : value});
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Done'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Dismiss the dialog
                              // Here you could also save the preference if needed
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text('Help & Support'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Need help?'),
                    content: Text(
                        'If you encountered a problem, you can either visit our FAQ page or email us directly for support.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('FAQ'),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Dismissing the dialog first
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FAQPage(),
                            ),
                          );
                        },
                      ),
                      TextButton(
                        child: Text('Email Us'),
                        onPressed: () async {
                          Navigator.of(context)
                              .pop(); // Dismissing the dialog first
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'fitnesssports0011@gmail.com',
                            query: encodeQueryParameters(
                                {'subject': 'Help Needed'}),
                          );
                          if (await canLaunch(emailLaunchUri.toString())) {
                            await launch(emailLaunchUri.toString());
                          } else {
                            // If can't launcha email, show an error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('No email app available.'),
                              ),
                            );
                          }
                        },
                      ),
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text('Log Out'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Log Out'),
                    content: Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismissing the dialog
                        },
                      ),
                      TextButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          // remove the user id from the shared preferences cache
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.remove("UserID");
                          if (await GoogleSignIn().isSignedIn()) {
                            GoogleSignIn().signOut();
                          }
                          Navigator.of(context).pop(); //Dismissing the dialog
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()),
                            ModalRoute.withName('/login'),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Settings(),
  ));
}
