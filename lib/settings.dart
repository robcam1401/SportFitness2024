import 'package:exercise_app/loginScreen.dart';
import 'package:flutter/material.dart';
import 'profile_settings.dart';
import 'account_settings.dart';

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
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
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
              // Navigate to help & support page
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
                        onPressed: () {
                          Navigator.of(context).pop(); //Dismissing the dialog
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginScreen()),
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
