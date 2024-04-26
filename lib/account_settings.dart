import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String _username = "";
  String _email = "";
  String _phoneNumber = "";
  String _download = "";

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
            Text(
              'Change Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text(
                'Select from your device',
                style: TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  File file = File(result.files.single.path!);
                  print(file.path);
                  final storageRef = FirebaseStorage.instance.ref();
                  var uuid = Uuid();
                  String fileName = "${uuid.v4()}.jpg";
                  print("Uploading $fileName");
                  final nameRef = storageRef.child(fileName);
                  try {
                      nameRef.putFile(file).snapshotEvents.listen((taskSnapshot) async {
                      switch (taskSnapshot.state) {
                    case TaskState.running:
                    Fluttertoast.showToast(
                      msg: "Upload In Progress",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                      print("Uploading");
                      break;
                    case TaskState.paused:
                      // ...
                      break;
                    case TaskState.success:
                      _download = await nameRef.getDownloadURL(); 
                      Fluttertoast.showToast(
                        msg: "Upload Done",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                      print("Uploaded");
                      break;
                    case TaskState.canceled:
                      // ...
                      break;
                    case TaskState.error:
                      print("Upload Error");
                      break;
                  }
                });
                  } on FirebaseException catch (e) {
                    print("Upload Error $e");
                  }
                } else {
                  print("User Exited the Picker");
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors
                    .white, backgroundColor: Colors.red[600], // Text color for the ElevatedButton style
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
    dynamic db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString("UserID")!;
    await db.collection("UserAccount").doc(UserID).get().then(
      (DocumentSnapshot doc) {
        Map data = doc.data() as Map<String, dynamic>;
        if (_username == "") {
          _username = data["Username"];
        } 
        if (_email == "") {
          _email = data["Email"];
        }
        if (_phoneNumber == "") {
          _phoneNumber = data["PhoneNumber"];
        }
      }
    );
    // Implement logic to update account settings
    print('Updated Username: $_username');
    print('Updated Email: $_email');
    print('Updated Phone Number: $_phoneNumber');
    await db.collection("UserAccount").doc(UserID).update({"Username": _username}); 
    await db.collection("UserAccount").doc(UserID).update({"Email": _email});    
    await db.collection("UserAccount").doc(UserID).update({"PhoneNumber": _phoneNumber});   
    if (_download != "") {
      await db.collection("UserAccount").doc(UserID).update({"ProfilePicture" : _download});
    } 
  }
}

void main() {
  runApp(MaterialApp(
    home: AccountSettingsPage(),
  ));
}
