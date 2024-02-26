import 'dart:math';
import 'package:flutter/material.dart';
import 'codeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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

  bool _showFullNameCheck = false;
  bool _showGmailCheck = false;
  bool _showUsernameCheck = false;
  bool isSendingEmail = false;

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
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    ElevatedButton(
                      onPressed: () {
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
    super.dispose();
  }
}
