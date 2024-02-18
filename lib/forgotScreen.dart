import 'package:exercise_app/loginScreen.dart';
import 'package:flutter/material.dart';
//import 'package:SportFitness2024/loginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class forgotScreen extends StatefulWidget {
  const forgotScreen({Key? key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<forgotScreen> {
  final TextEditingController _gmailController = TextEditingController();
  bool _showGmailCheck = true;
  bool isSendingEmail = false;

  @override
  void initState() {
    super.initState();
    _gmailController.addListener(() {
      final text = _gmailController.text;
      setState(() {
        _showGmailCheck = text.contains("@gmail.com") && text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _gmailController.dispose();
    super.dispose();
  }

  Future<void> sendEmail(String emailAddress) async {
    if (isSendingEmail) return; //for checking if email is already being sent
    setState(() {
      isSendingEmail = true; // Preventing multiple sends
    });

    String username = 'fitnesssports0011@gmail.com';
    String password = 'jgti jgfk onza wnjh';

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add(emailAddress)
      ..subject = 'Your Password Reset Link'
      ..text = 'This is your password reset link: http://yourlink.com';

    try {
      final sendReport = await send(message, smtpServer);
      Fluttertoast.showToast(
        msg: "Reset link sent: ${sendReport.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      // Navigate to the loginScreen after showing toast.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => loginScreen(),
        ),
      );
    } on MailerException catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to send reset link. ${e.toString()}",
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
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
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
                        labelText: 'Gmail',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffB81736),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    GestureDetector(
                      onTap: () {
                        print(
                            'Send Reset Link tapped'); // Debug: Check if tap is detected
                        if (_showGmailCheck && !isSendingEmail) {
                          print(
                              'Valid Gmail detected, attempting to send email'); // Debug: Check if email is valid
                          sendEmail(_gmailController.text);
                        } else if (!isSendingEmail) {
                          Fluttertoast.showToast(
                            msg: "Please enter a valid Gmail address",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        }
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
                          child: isSendingEmail
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Send Reset Link',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
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
                            "Remember your password??",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => loginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
