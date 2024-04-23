import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String _username = 'example_username';
  String _email = 'example@example.com';
  String _phoneNumber = '+1234567890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Username',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'New Username'),
              onChanged: (value) {
                // Update the new username
                _username = value;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Change Email',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'New Email'),
              onChanged: (value) {
                // Update the new email
                _email = value;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Change Phone Number',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'New Phone Number'),
              onChanged: (value) {
                // Update the new phone number
                _phoneNumber = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to update account settings
                _updateAccountSettings();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateAccountSettings() async {
    // Implement logic to update account settings
    print('Updated Username: $_username');
    print('Updated Email: $_email');
    print('Updated Phone Number: $_phoneNumber');
        dynamic db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString("UserID")!;
    await db.collection("UserAccount").doc(UserID).update({"Username": "$_username"}); 
    await db.collection("UserAccount").doc(UserID).update({"Email": "$_email"});    
    await db.collection("UserAccount").doc(UserID).update({"PhoneNumber": "$_phoneNumber"});    
  }
}

void main() {
  runApp(MaterialApp(
    home: AccountSettingsPage(),
  ));
}
