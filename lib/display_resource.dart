// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'lesson_booking_page.dart';
import 'post_card.dart';
import 'package:exercise_app/other_profile.dart';

class DisplayResource extends StatelessWidget {
  final String resourceID;

  DisplayResource({required this.resourceID});
  
  Future<DocumentSnapshot> fetchResource() async {
    return await FirebaseFirestore.instance.collection('Resources').doc(resourceID).get();
  }
  Future<DocumentSnapshot> fetchUserData(String userID) async {
    return await FirebaseFirestore.instance.collection('UserAccount').doc(userID).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resource Details'),
      ),
      body: FutureBuilder(
        future: fetchResource(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading resource details'),
            );
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic> resourceData = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resourceData['Name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${resourceData['Description']}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Display user details who uploaded the resource as a clickable button
                  GestureDetector(
                    onTap: () {
                      // Navigate to otherProfile page with the user's ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => otherProfile(posterID: resourceData['UserID']),
                        ),
                      );
                    },
                    child: FutureBuilder(
                      future: fetchUserData(resourceData['UserID']),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (userSnapshot.hasError) {
                          return Center(
                            child: Text('Error loading user details'),
                          );
                        }

                        if (userSnapshot.hasData && userSnapshot.data!.exists) {
                          Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '  By:  ',
                                style: TextStyle(fontSize: 19),
                              ),
                              CircleAvatar(
                                backgroundImage: NetworkImage(userData['ProfilePicture']),
                                radius: 27,
                              ),
                              SizedBox(width: 8),
                              Text(
                                    '${userData['FullName']}',
                                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        }
                        return Center(
                          child: Text('Uploader details not found'),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Center the "Book" button and move it to the end of the page
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement the action when the "Book" button is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonBookingPage(
                                name: resourceData['Name'],
                                resourceID: resourceID,
                                numPlayers: resourceData['PeopleAmount'],
                                bookDate: resourceData['Date'],
                                duration: resourceData['HoursAmount'],
                                price: resourceData['Price'],
                              ),
                            ),
                          );
                        },
                        child: Text('Book'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }


          return Center(
            child: Text('Resource not found'),
          );
        },
      ),
    );
  }

  

}
