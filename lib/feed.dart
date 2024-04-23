import 'dart:io';
import 'package:exercise_app/friends.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_card.dart';

const LatLng sourceLocation = LatLng(32.53021599903092, -92.65212084047921);

class Feed extends StatefulWidget {
  @override
  State<Feed> createState() => _Feed();
}

class _Feed extends State<Feed> {
  dynamic postData;
  String UserID = '';

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // to make background transparent
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Create new post',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        size: 50,
                        color: Colors.grey[800],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Drag photos and videos here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      ElevatedButton(
                        child: Text(
                          'Select from your device',
                          style: TextStyle(
                            color: Colors.white, // Text color
                          ),
                        ),
                        onPressed: () {
                          filePicker();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors
                              .white, backgroundColor: Colors.red[600], // Text color for the ElevatedButton style
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness & Sports App',
            style: TextStyle(
              fontFamily: 'DancingScript',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 241, 241),
            )),
        actions: [
          IconButton(
            onPressed: _showUploadSheet,
            icon: Icon(Icons.add_box_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Friends()));
            },
            icon: Icon(Icons.messenger_outline),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      //  body: ListView.builder(
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("Pictures").orderBy("UploadDate",descending: true).limit(10).get(),
          builder: ((BuildContext context, AsyncSnapshot snapshot) {
            Widget pc;
            if (snapshot.hasData) {
              pc = FutureBuilder(
                future: postCardBuilder(snapshot.data.docs),
                builder: ((BuildContext context, AsyncSnapshot snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.done && snapshot2.hasData) {
                      List pics = snapshot2.data;
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return PostCard(
                            postUrl: pics[index]["Link"],
                            userImage: pics[index]["ProfilePicture"],
                            description: pics[index]["Description"],
                            username: pics[index]["Username"],
                            likes: pics[index]["Likes"],
                            comments: pics[index]["Comments"],
                            timestamp: pics[index]["UploadDate"],
                            UserID: UserID,
                            postID: pics[index]["PostID"],
                            isLiked: pics[index]["isLiked"],
                            isBookmarked: pics[index]["isBookmarked"],
                            posterID: pics[index]["Poster"]
                          );
                        }
                      );
                  }
                  else if (snapshot2.hasError) {
                    print("Error: ${snapshot2.error}");
                    return Text("Snapshot2 Error");
                  }
                  else {
                    return const Expanded(child: Center(child: CircularProgressIndicator()));
                  }
                }
                )
              );
              // return the widget stuff
            }
            else if (snapshot.hasError) {
              pc = const Text("Error");
            }
            else {
              pc = const Text("Loading");
            }
            return pc;
          })
        )
    );
  }
  
  void filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
      } else {
        // User canceled the picker
      }
  }
  
  Future<List> postCardBuilder(docs) async {
    dynamic db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserID = prefs.getString("UserID")!;
    List pics = [];
    for (var doc in docs) {
      DocumentReference docRef = await db.collection("Pictures").doc(doc.id);
      await docRef.get().then(
        (DocumentSnapshot data) async {
          Map pic = data.data() as Map<String, dynamic>;
          pic["PostID"] = doc.id;
          await db.collection("Likes").where("PostID", isEqualTo: doc.id).where("UserID", isEqualTo: UserID).get().then(
            (querySnapshot) {
              if (!querySnapshot.docs.isEmpty) {
                pic["isLiked"] = true;
              }
              else {
                pic["isLiked"] = false;
              }
            }
          );
          await db.collection("Bookmarks").where("PostID", isEqualTo: doc.id).where("UserID", isEqualTo: UserID).get().then(
            (querySnapshot) {
              if (!querySnapshot.docs.isEmpty) {
                pic["isBookmarked"] = true;
              }
              else {
                pic["isBookmarked"] = false;
              }
            }
          );
          pics.add(pic);
        }
        );
    }
    int i = 0;
    for (var item in pics) {
      DocumentReference docRef = await db.collection("UserAccount").doc(item["Poster"]);
      await docRef.get().then(
        (DocumentSnapshot data) {
          final data2 = data.data() as Map<String, dynamic>;
          pics[i]["Username"] = data2["Username"];
          pics[i]["ProfilePicture"] = data2["ProfilePicture"];
          i = i + 1;
        }
      );
    }
    return pics;
  }
}