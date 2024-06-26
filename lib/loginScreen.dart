import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:exercise_app/feed.dart';
import 'package:exercise_app/main.dart';
import 'package:exercise_app/forgotScreen.dart';
import 'package:exercise_app/regScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dbInterface.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_application_1/forgotScreen.dart';
//import 'package:flutter_application_1/regScreen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<loginScreen> {
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showGmailCheck = false;
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _gmailController.addListener(() {
      final text = _gmailController.text;
      final showCheck = text.contains("@gmail.com");
      setState(() => _showGmailCheck = showCheck);
    });
    _passwordController.addListener(() {
      final text = _passwordController.text;
      final showCheck = text.length >= 5 && text.length <= 30;
    });
  }

  @override
  void dispose() {
    _gmailController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  child: Text("Hello\nLog In!",
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
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          label: Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => forgotScreen()));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff281537),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                        final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _gmailController.text, password: _passwordController.text);
                        if (cred.user?.uid != null) {
                          String UserID = cred.user!.uid;
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("UserID", UserID);
                          Navigator.push(context, MaterialPageRoute(builder:(context) => Home()));
                        }
                        else {
                          Fluttertoast.showToast(
                            msg: "Invalid Email or Password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                          print("Invalid email or password");
                        }
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: "Invalid Email or Password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                          print("Invalid email or password");
                          print(e);
                        }


                        // Map loginInfo = <String, dynamic>{
                        //   'Email' : _gmailController.text,
                        //   'PasswordHash' : sha256.convert(utf8.encode(_passwordController.text)).toString()
                        // };

                        // dynamic db = FirebaseFirestore.instance; 
                        // bool login = false;
                        // db.collection('UserAccount').where('Email', isEqualTo: loginInfo['Email']).where('PasswordHash', isEqualTo: loginInfo['PasswordHash']).get().then(
                        //   (querySnapshot) {
                        //     print("Completed");
                        //     for (var doc in querySnapshot.docs) {
                        //       loginUser(doc.id);
                        //       login = true;
                        //       Navigator.push(context, MaterialPageRoute(builder:(context) => Home()));
                        //     }
                        //     if (!login){
                        //       Fluttertoast.showToast(
                        //         msg: "Invalid Email or Password",
                        //         toastLength: Toast.LENGTH_SHORT,
                        //         gravity: ToastGravity.CENTER,
                        //       );
                        //       print("Invalid email or password");
                        //     }
                        //   }
                        // );       
                        // FutureBuilder(
                        //   future: db.collection('UserAccount').where("Email", isEqualTo: loginInfo["Email"]).where("PasswordHash", isEqualTo: loginInfo['PasswordHash']).get(),
                        //   builder:
                        //     ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        //       print("HEre");
                        //       if (snapshot.hasError) {
                        //         print("Error logging in");
                        //         Fluttertoast.showToast(
                        //           msg: "Please try again later",
                        //           toastLength: Toast.LENGTH_SHORT,
                        //           gravity: ToastGravity.CENTER,
                        //         );
                        //       };
                        //       if (snapshot.hasData && snapshot.data!.size == 0) {
                        //         Fluttertoast.showToast(
                        //           msg: "Invalid Username or Password",
                        //           toastLength: Toast.LENGTH_SHORT,
                        //           gravity: ToastGravity.CENTER,
                        //         );
                        //       };
                        //       if (snapshot.connectionState == ConnectionState.done) {
                        //         Fluttertoast.showToast(
                        //           msg: "Welcome",
                        //           toastLength: Toast.LENGTH_SHORT,
                        //           gravity: ToastGravity.CENTER,
                        //         );
                        //         UserIDCache(snapshot.data?.docs[0].id);
                        //         Navigator.push(context, MaterialPageRoute(builder:(context) => Home()));
                        //       }
                        //       Fluttertoast.showToast(
                        //         msg: "Loading",
                        //         toastLength: Toast.LENGTH_SHORT,
                        //         gravity: ToastGravity.CENTER,
                        //       );
                        //       return Text("WHEE");
                        //     })
                        // );
                        // dbLogin(loginInfo).then((Map login) {
                        //   print(login);

                        //   while (!login['done']) {
                        //     print('loading');
                        //   }
                        //   if (login['login']) {
                        //     Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Home()));
                        //   }
                        //   else {
                        //     Fluttertoast.showToast(
                        //       msg: "Invalid Username or Password",
                        //       toastLength: Toast.LENGTH_SHORT,
                        //       gravity: ToastGravity.CENTER,
                        //     );
                        //   }
                        // });

                      },
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(colors: [
                            Color(0xff881736),
                            Color(0xff281537),
                          ]),
                        ),
                        child: Center(
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => regScreen()));
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void loginUser(userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserID', userID);
  }
}
