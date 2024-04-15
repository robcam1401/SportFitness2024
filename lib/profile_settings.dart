import 'package:flutter/material.dart';
import 'dart:convert';
import 'dbInterface.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
    String userName = '';

  void fetchUserName() async {
    Query query = Query();
    int myAccountNumber = 1; // Replace with your actual account number
    Map response = await Query().account_name(myAccountNumber);
    String firstName = response['first'];
    String lastName = response['last'];
    // Update the state with the user's name
    setState(() {
      userName = '$firstName $lastName';
    });
  }

  String _bio = 'Tennis player';
  String _website = 'vsco.co/olgabien';
  String _gender = 'Female'; // Assuming Female is the default

  // Method to update profile information
  void _updateProfile() {
    // Implement logic to update profile here
    // For simplicity, just print updated information
    print('Updated Name: $userName');
    print('Updated Bio: $_bio');
    print('Updated Website: $_website');
    print('Updated Gender: $_gender');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Edit Name'),
              subtitle: Text(userName),
              onTap: () {
                // Show dialog to edit name
                showDialog(
                  context: context,
                  builder: (_) => _buildEditNameDialog(),
                );
              },
            ),
            ListTile(
              title: Text('Edit Bio'),
              subtitle: Text(_bio),
              onTap: () {
                // Show dialog to edit bio
                showDialog(
                  context: context,
                  builder: (_) => _buildEditBioDialog(),
                );
              },
            ),
            ListTile(
              title: Text('Edit Website'),
              subtitle: Text(_website),
              onTap: () {
                // Show dialog to edit website
                showDialog(
                  context: context,
                  builder: (_) => _buildEditWebsiteDialog(),
                );
              },
            ),
            ListTile(
              title: Text('Gender (not visible on your profile)'),
              subtitle: Text(_gender),
              onTap: () {
                // Show dialog to select gender
                showDialog(
                  context: context,
                  builder: (_) => _buildGenderSelectionDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditNameDialog() {
    return AlertDialog(
      title: Text('Edit Name'),
      content: TextField(
        decoration: InputDecoration(hintText: 'Enter your name'),
        onChanged: (value) {
          setState(() {
            userName = value;
          });
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildEditBioDialog() {
    return AlertDialog(
      title: Text('Edit Bio'),
      content: TextField(
        decoration: InputDecoration(hintText: 'Enter your bio'),
        onChanged: (value) {
          setState(() {
            _bio = value;
          });
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildEditWebsiteDialog() {
    return AlertDialog(
      title: Text('Edit Website'),
      content: TextField(
        decoration: InputDecoration(hintText: 'Enter your website'),
        onChanged: (value) {
          setState(() {
            _website = value;
          });
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildGenderSelectionDialog() {
    return AlertDialog(
      title: Text('Select Gender'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Male'),
            onTap: () {
              setState(() {
                _gender = 'Male';
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Female'),
            onTap: () {
              setState(() {
                _gender = 'Female';
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Other'),
            onTap: () {
              setState(() {
                _gender = 'Other';
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileSettingsPage(),
  ));
}
