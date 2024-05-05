import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'lesson_booking_page.dart';
import 'post_card.dart';

// ignore: must_be_immutable
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
  String fullName = '';
  String biography = '';
  String website = 'https://www.google.com';
  List pics = [];

  List<Map<String, dynamic>> _bookedResources = [];
  bool isFriend = false;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    print(widget.posterID);
    await db.collection("UserAccount").doc(UserID).get().then(
      (DocumentSnapshot doc) {
        Map data = doc.data() as Map<String, dynamic>;
        print("Here: ${data}");
        userName = data["Username"];
        followerCount = data["Followers"];
        fullName = data["FullName"];
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
      return Scaffold(
        appBar: AppBar(
          title: Text(""),
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
                isFriend = true;
              }
              //means friend sent request
              else if (requestCheck2.exists){
                dynamic acceptfriend = await db.collection("Friends").doc("$User2ID$User");
                acceptfriend.update({"User2Accepted":"true"});
                isFriend = false;
              }       
              // no request 
              else{
                isFriend = true;
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
                  'Sender': User
                };
                db.collection("Notifications").doc().set(sendNotification);
                await db.collection("UserAccount").doc(User2ID).get().then(
                  (DocumentSnapshot doc2) {
                    Map data2 = doc2.data() as Map<String, dynamic>;
                    db.collection("UserAccount").doc(doc2.id).update({"Followers" : data2["Followers"] + 1});
                  }
                );
                await db.collection("UserAccount").doc(UserID).get().then(
                  (DocumentSnapshot doc3) {
                    Map data3 = doc3.data() as Map<String, dynamic>;
                    db.collection("UserAccount").doc(doc3.id).update({"Followers" : data3["Followers"] + 1, "Following" : data3["Following"] + 1});
                  }
                );
              
              }   
            },
            icon: Icon(
              (isFriend) ? Icons.person: Icons.person_add 
            ),
          ),
        ],
        ),
        body: FutureBuilder(
          future: fetchUserInfo(),
          builder: ((BuildContext context, AsyncSnapshot snapshot) {
            Widget pc;
            if (snapshot.connectionState == ConnectionState.done) {
              pc = Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(profilePicture),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '$fullName',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '@$userName',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 3),
                  Text(
                    biography,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Followers: $followerCount',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Following: $followingCount',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      if (website.isNotEmpty) {
                        await launch(website);
                      } else {
                        print('No website provided');
                      }
                    },
                    child: Text("My Website"),
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
            print(querySnapshot.docs);
            if (!querySnapshot.docs.isEmpty) {
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

// ignore: must_be_immutable
class PostCardScreen extends StatelessWidget {
  final String userImage;
  final String username;
  final String postUrl;
  final String description;
  final Timestamp timestamp;
  int likes;
  int comments;
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
