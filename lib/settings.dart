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
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingsPage()));
            },
          ),
          ListTile(
            title: Text('Account Settings'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsPage()));
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
              // Navigate to privacy settings page
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
              // Implement log out functionality
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