import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/friends.dart';
import 'package:exercise_app/profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CaptionAndShareScreen extends StatefulWidget {
  final File imageFile;
  final String UserID;

  const CaptionAndShareScreen({Key? key, required this.imageFile, required this.UserID})
      : super(key: key);

  @override
  _CaptionAndShareScreenState createState() => _CaptionAndShareScreenState();
}

class _CaptionAndShareScreenState extends State<CaptionAndShareScreen> {
  final TextEditingController _captionController = TextEditingController();

  _print2() {
    print("pressed");
    return;
  }

  _uploadAndShare2() {
    // TODO: Implement the upload and share functionality
    print("Caption: ${_captionController.text}");
    bool completed = false;
    try {
      final storageRef = FirebaseStorage.instance.ref();
      var uuid = Uuid();
      String filename = "${uuid.v4()}.jpg";
      final nameRef = storageRef.child(filename);
      nameRef.putFile(widget.imageFile).snapshotEvents.listen((taskSnapshot) async {
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
        String download = await nameRef.getDownloadURL(); 
        Fluttertoast.showToast(
          msg: "Upload Done",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
          print("Uploaded");
          if (!completed)
          {  FirebaseFirestore.instance.collection("Pictures").add(
              {
                "Comments" : 0,
                "Description" : _captionController.text,
                "Likes" : 0,
                "Link" : download,
                "Poster" : widget.UserID,
                "UploadDate" : DateTime.timestamp()
              }
          );
          completed = true;
          }
        case TaskState.canceled:
          // ...
          break;
        case TaskState.error:
          print("Upload Error");
      }
      });
    }
    on FirebaseException catch (e) {
      print(e);
    }
    // Upload image and caption to your backend or Firebase
    Navigator.pop(context); 
  }

  _uploadAndShare(file, String UserID) {
    // TODO: Implement the upload and share functionality
    print("Caption: ${_captionController.text}");
    bool completed = false;
    try {
      final storageRef = FirebaseStorage.instance.ref();
      // create a new link-safe random name for the file
      var uuid = Uuid();
      String fileName = "${uuid.v4()}.jpg";
      final nameRef = storageRef.child(fileName);
      // upload the file
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
        String download = await nameRef.getDownloadURL(); 
        Fluttertoast.showToast(
          msg: "Upload Done",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
          print("Uploaded");
          if (!completed)
          {  FirebaseFirestore.instance.collection("Pictures").add(
              {
                "Comments" : 0,
                "Description" : _captionController.text,
                "Likes" : 0,
                "Link" : download,
                "Poster" : UserID,
                "UploadDate" : DateTime.timestamp()
              }
          );
          completed = true;
          }
        case TaskState.canceled:
          // ...
          break;
        case TaskState.error:
          print("Upload Error");
      }
      });
  } on FirebaseException catch (e) {
    print("Upload Error $e");
  }
    // Upload image and caption to your backend or Firebase
    // Navigator.pop(context); // Return to the previous screen after sharing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Add Caption and Share',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: null
            //onPressed: _uploadAndShare(widget.imageFile, widget.UserID),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Image.file(widget.imageFile)),
          TextField(
            controller: _captionController,
            decoration: InputDecoration(
              labelText: 'Write a caption...',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          ElevatedButton(
            onPressed: _uploadAndShare2,
            //onPressed: _uploadAndShare(widget.imageFile, widget.UserID),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Share'),
          ),
        ],
      ),
    );
  }
}


const LatLng sourceLocation = LatLng(32.53021599903092, -92.65212084047921);

class Feed extends StatefulWidget {
  @override
  State<Feed> createState() => _Feed();
}

class _Feed extends State<Feed> {
  // postData will be populated with a list of posts to build the feed
  // UserID is populated from the shared preferences cache
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
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            // grab the path of the selected file
                            File file = File(result.files.single.path!);
                            // uploading the file
                            Navigator.pop(context); // Close the bottom sheet
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CaptionAndShareScreen(imageFile: file, UserID: UserID,)),
                            );
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
          IconButton(
            onPressed: () {
              setState((){});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      //  body: ListView.builder(
        // future builder to build the feed
        // made of two future builders, the first gets the posts from the database
        // the second passes the posts into a function to create the post card list
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
  
  // given the list of firebase docs, builds the post data list
  Future<List> postCardBuilder(docs) async { 
    // init the database and get the user id from cache
    dynamic db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserID = prefs.getString("UserID")!;
    List pics = [];
    // iterating through the docs, grab the necessary data
    for (var doc in docs) {
      //print(doc.data() as Map<String, dynamic>);
      DocumentReference docRef = await db.collection("Pictures").doc(doc.id);
      await docRef.get().then(
        (DocumentSnapshot data) async {
          Map pic = data.data() as Map<String, dynamic>;
          // post id uniquely identifies each post. it is used to count likes, bookmarks, and comments
          pic["PostID"] = doc.id;
          await db.collection("Likes").where("PostID", isEqualTo: doc.id).where("UserID", isEqualTo: UserID).get().then(
            (querySnapshot) {
              // find if the user has previously liked or bookmarkes the post
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
    // for each item in pics, grab the username and profile picture of the user that uploaded the post
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