import 'package:exercise_app/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'regScreen.dart';
import 'loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xffB81736),
          Color(0xff2A1639),
        ])),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align to the start of the column
          children: [
            SizedBox(
              height: 100, // Adjust the space as needed
            ),
            Image.asset('assets/Images/dumbbell.png', width: 400, height: 200),
            SizedBox(
              height: 70,
            ),
            Text(
              'Sport Trainer',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => loginScreen()));
              },
              child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                      child: Text('LOGIN',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)))),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => regScreen()));
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SignInButton(
                Buttons.Google,
                text: "Sign up with Google",
                onPressed: () async {
                try {
                  // set the scope of the sign in
                  const List<String> scopes = <String>[
                    'email',
                  ];

                  GoogleSignIn _googleSignIn = GoogleSignIn(
                    // Optional clientId
                    // clientId: 'your-client_id.apps.googleusercontent.com',
                    scopes: scopes,
                  );
                  // Trigger the authentication flow
                  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

                  // Obtain the auth details from the request
                  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

                  // Create a new credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth?.accessToken,
                    idToken: googleAuth?.idToken,
                  );
                  // Once signed in, return the UserCredential
                  String UserID = FirebaseAuth.instance.currentUser!.uid;
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("UserID", UserID);
                  Navigator.push(context, MaterialPageRoute(builder:(context) => Home()));
                } catch(e) {
                  Fluttertoast.showToast(
                    msg: "Error Signing In With Google",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                  print("Error: $e");
                }
              },
              ),
              // child: Container(
              //   height: 53,
              //   width: 320,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(30),
              //     border: Border.all(color: Colors.white),
              //   ),
              //   child: const Center(
              //     child: Text(
              //       'SIGN IN WITH GOOGLE',
              //       style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black),
              //     ),
              //   ),
              // ),

            Spacer(),
          ],
        ),
      ),
    );
  }
}
