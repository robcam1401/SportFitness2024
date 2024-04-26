import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'lesson_booking_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'video_analysis_page.dart';
import 'post_card.dart';
import 'dart:convert';
import 'dbInterface.dart';
import 'resource.dart';
import 'myresources.dart';

class otherProfile extends StatefulWidget {

  @override
  State<otherProfile> createState() => _otherProfile();
    String posterID;

  otherProfile({
    Key? key,
    required this.posterID,
  }) : super(key: key);
}

class _otherProfile extends State<otherProfile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userName = '';
  String UserID = ''; // Replace with actual account number
  int followingCount = 0;
  int followerCount = 0;
  String profilePicture = '';
  String biography = '';
  String website = 'https://www.google.com';
  List pics = [];
  List<Map<String, dynamic>> _bookedResources = [];

  @override
  void initState() async {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<List> postCardBuilder(docs) async {
    dynamic db = FirebaseFirestore.instance;
    UserID = widget.posterID;
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

  Future<String> fetchUserInfo() async {
    dynamic db = FirebaseFirestore.instance;
    UserID = widget.posterID;
    await db.collection("UserAccount").doc(UserID).get().then(
      (DocumentSnapshot doc) {
        Map data = doc.data() as Map<String, dynamic>;
        userName = data["Username"];
        followerCount = data["Followers"];
        followingCount = data["Following"];
        profilePicture = data["ProfilePicture"];
        biography = data["Biography"];
        if (data["Website"] != null) {
          website = data["Website"];
        }
        return ("Profile Completed");
      }
    );
    await db.collection("Pictures").where("Poster", isEqualTo: UserID).get().then(
      (querySnapshot) async {
            pics = await postCardBuilder(querySnapshot.docs);
      }

    );

    return ("Profile Loading");
  }

  //int followingCount = 100;
  String profileID = 'abc';
  //String UserID = 'abc';
  String confirmation = 'abc';
  bool isAdded = false;

  @override

  Widget build(BuildContext context) {
    List<Service> services = [
      Service(
        id: '1',
        name: 'One-on-One Lessons',
        resources: [
          Resource(
            id: '1',
            name: 'Tennis Lesson',
            description: '',
            available: true,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LessonBookingPage(name:'1',resourceID:'test', numPlayers: false, bookDate: false,duration: false,priceHour: 1,pricePerson: 1,)));
            },
          ),
        ],
      ),
      Service(
        id: '2',
        name: 'Video Analysis',
        resources: [
          Resource(
            id: '2', 
            name: 'Video Analysis Session', 
            description: '',
            available: true),
        ],
      ),
      // Add more services as needed
    ];

      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
          IconButton(
            onPressed: () async {
              dynamic db = FirebaseFirestore.instance;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String User = prefs.getString("UserID")!;
              String User2ID = widget.posterID;
              dynamic requestCheck1 = await db.collection("Friends").doc("$User$User2ID").get();
              dynamic requestCheck2 = await db.collection("Friends").doc("$User2ID$User").get();
              //means owner sent request
              if(requestCheck1.exists){  
                
              }
              //means friend sent request
              else if (requestCheck2.exists){
                dynamic acceptfriend = await db.collection("Friends").doc("$User2ID$User");
                acceptfriend.update({"User2Accepted":"true"});
              }       
              // no request 
              else{
                Map friendinfo = <String, dynamic>{
                  'User1ID' : User,
                  'User2ID' : User2ID,
                  'User1Accepted' : "true",
                  'User2Accepted' : "false",
                };
                db.collection("Friends").doc("$User$User2ID").set(friendinfo);
                Map sendNotification = <String, dynamic>{
                  'Owner' : User2ID,
                  'Time' : Timestamp.now(),
                  'Type' : "friend request",
                };
                db.collection("Notifications").doc().set(sendNotification);
              
              
              }   
            },
            icon: Icon(Icons.person_add),
          ),
        ],
        ),
        body: FutureBuilder(
          future: fetchUserInfo(),
          builder: ((BuildContext context, AsyncSnapshot snapshot) {
            Widget pc;
            if (snapshot.connectionState == ConnectionState.done) {
              pc = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 20), // Adding space for better alignment
                      CircleAvatar(
                        radius: 40,
                        // Your profile picture
                        backgroundImage: NetworkImage(profilePicture),
                      ),
                      SizedBox(width: 20), // Adding space between bio and counts
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Following: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                followingCount.toString(), // Your following count
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                'Followers: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${followerCount}", // Your followers count
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 20), // Adding space between profile picture and name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\t\t$userName',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '  ${biography}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      ElevatedButton(
                        onPressed:() async {
                          Uri url = Uri.parse(website); // personal website url
                          await launchUrl(url);
                        },
                        child: Text("My Website")
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Feed'),
                      Tab(text: 'Resources'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Feed Tab
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: pics.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onLongPress: () {
                                showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: <Widget>[
                              // InkWell(
                              //   child: Container(
                              //     height: 50,
                              //     child: const Center (child: Text('Delete'))
                              //   ),
                              // ),
                              InkWell(
                                onTap: () {FirebaseFirestore.instance.collection("Pictures").doc(pics[index]["PostID"]).delete();
                                          Navigator.of(context).pop();},
                                child: Container(
                                  height: 50,
                                  child: const Center(child: Text('Delete')),
                                ),
                              )
                            ]
                          ),
                        ),
                        );
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostCardScreen(
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
                                    ),
                                    
                                  ),
                                );
                              },
                              child: Container(
                                width: 200, // Adjust width as needed
                                height: 200, // Adjust height as needed
                                child: Image(
                                  image: NetworkImage(pics[index]["Link"]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                        // Resources Tab
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              FutureBuilder(
                                future: buildResources(),
                                builder: ((BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    List<Resource> resources = snapshot.data;
                                    Widget rl = Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: resources.map((resource) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ListTile(
                                              title: Text(
                                                resource.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              subtitle: Text(
                                                resource.description, // Assuming description exists in your Resource class
                                              ),
                                              trailing: ElevatedButton(
                                                onPressed: resource.onPressed,
                                                child: Text('Select'),
                                              ),
                                            ),
                                            Divider(), 
                                          ],
                                        );
                                      }).toList(),
                                    );
                                    return rl;
                                  }
                                  else if (snapshot.hasError) {
                                    print("Resource List Snapshot Error");
                                    return Text("Resource List Snapshot Error");
                                  }
                                  else {
                                    return CircularProgressIndicator();
                                  }
                                })
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              return pc;
            }
            else {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }
            
          })
        )
      );
    }
    
      Future<List<Resource>> buildResources() async {
        List<Resource> resources = [];
        dynamic db = FirebaseFirestore.instance;
        await db.collection("Resources").where("UserID", isEqualTo: UserID).get().then(
          (querySnapshot) async {
            for (var doc in querySnapshot.docs) {
              Map resource = doc.data() as Map<String, dynamic>;
              Resource rc = Resource(
                id: doc.id,
                name: resource["Name"],
                description: resource["Description"],
                available: true,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LessonBookingPage(name: resource["Name"], resourceID: doc.id, numPlayers: resource["PeopleAmount"], bookDate: resource["Date"], duration: resource["HoursAmount"], priceHour: resource["PriceHour"],pricePerson: resource["PricePerson"],)));
                },
              );
            resources.add(rc);
            }
          }
        );
        return resources;
      }
}
  

class PostWidget extends StatelessWidget {
  final ImageProvider image;
  final String caption;

  const PostWidget({
    required this.image,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image
          Image(image: image),
          SizedBox(height: 10),
          // Caption
          Text(
            caption,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class Service {
  final String id;
  final String name;
  final List<Resource> resources;

  Service({required this.id, required this.name, required this.resources});
}

class Resource {
  final String id;
  final String name;
  final String description;
  final bool available;
  final VoidCallback? onPressed;

  Resource({
    required this.id,
    required this.name,
    required this.description,
    required this.available,
    this.onPressed,
  });
}

class PostCardScreen extends StatelessWidget {
  final String userImage;
  final String username;
  final String postUrl;
  final String description;
  final Timestamp timestamp;
  int likes;
  int comments;
  final String text = "hello";
  final String UserID;
  final String postID;
  bool isLiked;
  bool isBookmarked;
  String posterID;

  PostCardScreen({
    required this.userImage,
    required this.username,
    required this.postUrl,
    required this.description,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.UserID,
    required this.postID,
    required this.isLiked,
    required this.isBookmarked,
    required this.posterID,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: PostCard(userImage: userImage, username: username, postUrl: postUrl, description: description, timestamp: timestamp, likes: likes, comments: comments, UserID: UserID, postID: postID, isLiked: isLiked, isBookmarked: isBookmarked, posterID: posterID),
    );
    
  }
}