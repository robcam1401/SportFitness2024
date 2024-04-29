import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'codeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class regScreen extends StatefulWidget {
  const regScreen({Key? key}) : super(key: key);
  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<regScreen> {
  bool _isObscured = true;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  // gonna make more, too. For phone number and birthdate
  final TextEditingController _DOBController = TextEditingController();

  bool _showFullNameCheck = false;
  bool _showGmailCheck = false;
  bool _showUsernameCheck = false;
  bool _showPasswordCheck = false;
  bool isSendingEmail = false;
  bool passwordMatch = false;
  bool inserted = false;
  bool _showDOBCheck = false;

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(() {
      final text = _fullNameController.text;
      final showCheck = text.length > 5 && text.length <= 30;
      setState(() => _showFullNameCheck = showCheck);
    });

    _gmailController.addListener(() {
      final text = _gmailController.text;
      final showCheck = text.contains("@gmail.com");
      setState(() => _showGmailCheck = showCheck);
    });

    _usernameController.addListener(() {
      final text = _usernameController.text;
      final showCheck = text.length >= 5 && text.length <= 30;
      setState(() => _showUsernameCheck = showCheck);
    });

    _DOBController.addListener(() {
      final text = _DOBController.text;
      setState(() => _showDOBCheck = text.isNotEmpty);
    });

    _passwordController.addListener(() {
      final text = _passwordController.text;
      final showCheck = text.length >= 5 && text.length <= 30;
      setState(() => _showPasswordCheck = showCheck);
    });
    _passwordController2.addListener(() {
      final text = _passwordController2.text;
      final showCheck = text.length >= 5 && text.length <= 30;
      setState(() => _showPasswordCheck = showCheck);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _DOBController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> sendVerificationCode(String emailAddress) async {
    if (isSendingEmail) return;
    setState(() {
      isSendingEmail = true;
    });

    final verificationCode = Random().nextInt(899999) + 100000; // 6-digit code

    String username = 'fitnesssports0011@gmail.com';
    String password = 'jgti jgfk onza wnjh';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your App Name')
      ..recipients.add(emailAddress)
      ..subject = 'Your Verification Code'
      ..text = 'Your verification code is: $verificationCode';

    try {
      await send(message, smtpServer);
      Fluttertoast.showToast(
        msg: "Verification code sent",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      // Navigate to codeScreen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => codeScreen(verificationCode: verificationCode),
        ),
      );
    } on MailerException catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to send verification code. ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      setState(() {
        isSendingEmail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xff881736),
                  Color(0xff281537),
                ]),
              ),
              child: const Padding(
                  padding: EdgeInsets.only(top: 60.0, left: 22),
                  child: Text("Create Your Account",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )))),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                          suffixIcon: _showFullNameCheck
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          label: Text(
                            'Full Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    TextField(
                      controller: _gmailController,
                      decoration: InputDecoration(
                          suffixIcon: _showGmailCheck
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          label: Text(
                            'Gmail',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          suffixIcon: _showUsernameCheck
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          label: Text(
                            'Username',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    TextField(
                      focusNode: AlwaysDisabledFocusNode(),
                      controller: _DOBController,
                      decoration: InputDecoration(
                          suffixIcon: _showDOBCheck
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          label: Text(
                            'Date Of Birth',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                      onTap: () => _selectDate(context),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          // Call this method when the icon is pressed
                          label: Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    TextField(
                      controller: _passwordController2,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          // Call this method when the icon is pressed
                          label: Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // check to see the passwords match
                        if (_passwordController.text == _passwordController2.text) {
                        // create the account_info map and pass into new_account
                          Map accountInfo = <String, dynamic>{
                            'Username' : _usernameController.text,
                            'Email' : _gmailController.text,
                            'FullName' : _fullNameController.text,
                            'PasswordHash' : _passwordController.text,
                            'Following' : 0,
                            'Followers' : 0,
                          };
                          newAccount(accountInfo);
                          // check if the new account is inserted
                          if (inserted) {
                            //check if the email has not aldready been sent and checks for valid gamial address
                            if (_showGmailCheck && !isSendingEmail) {
                              // calling sendVerificationCode
                              sendVerificationCode(_gmailController.text);
                            } else {
                              //showing toast message if the Gmail address is not valid
                              Fluttertoast.showToast(
                                msg: "Please enter a valid Gmail address",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                            }
                          }
                          else {
                            Fluttertoast.showToast(
                            msg : "Please try again later",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                          }
                        }
                        else {
                          //showing toast message if the Gmail address is not valid
                          Fluttertoast.showToast(
                            msg : "Passwords do not match",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xff881736), // Button background color
                        foregroundColor: Colors.white, // Text color
                        minimumSize: Size(300, 55), // Size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isSendingEmail
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _gmailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    _DOBController.dispose();
    super.dispose();
  }
  
  void newAccount(userInfo) async {
    dynamic db = FirebaseFirestore.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // get the password hash with sha-256
    var bytes = utf8.encode(userInfo['PasswordHash']);
    String digest = sha256.convert(bytes).toString();
    print('Password Digest: $digest');
    userInfo['PasswordHash'] = digest;
    db.collection("UserAccount").add(userInfo).then((DocumentReference doc) =>
    //print('DocumentSnapshot added with ID: ${doc.id}'));
    prefs.setString('UserID', doc.id), 
    onError: (e) => print('Error Registering: $e'),
    );
    inserted = true;
  }
}
