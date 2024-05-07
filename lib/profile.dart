import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'lesson_booking_page.dart';
import 'post_card.dart';
import 'resource.dart';
import 'myresources.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // required data for the profile information
  // initialized here, but replaced with information from the profile builder
  String userName = '';
  String UserID = '';
  int followingCount = 0;
  int followerCount = 0;
  String fullName = '';
  String profilePicture = '';
  String biography = '';
  String website = 'https://www.google.com';
  List pics = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // this creates the list of posts the user uploaded, similar to the feed
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

  // this is called when the page loads and grabs the user info from the db
  // populates the previously initialized profile variables
  Future<String> fetchUserInfo() async {
    dynamic db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserID = prefs.getString("UserID")!;
    print(UserID);
    // this creates the list of pictures the user uploaded and gets the post card list made
    await db.collection("Pictures").where("Poster", isEqualTo: UserID).get().then(
      (querySnapshot) async {
        pics = await postCardBuilder(querySnapshot.docs);
      }

    );
    await db.collection("UserAccount").doc(UserID).get().then(
      (DocumentSnapshot doc) {
        Map data = doc.data() as Map<String, dynamic>;
        userName = data["Username"];
        followerCount = data["Followers"];
        followingCount = data["Following"];
        fullName = data["FullName"];
        profilePicture = data["ProfilePicture"];
        biography = data["Biography"];
        if (data["Website"] != null) {
          website = data["Website"];
        }
        return ("Profile Completed");
      }
    );

    return ("Profile Loading");
  }


  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Notifications()));
            },
            icon: Icon(Icons.add_alert_rounded),
          ),
          IconButton(
            onPressed: () {
              setState((){});
            },
            icon: Icon(Icons.refresh),
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
                      Tab(text: 'Bookmarks'),
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
                              InkWell(
                                onTap: () async {FirebaseFirestore.instance.collection("Pictures").doc(pics[index]["PostID"]).delete();
                                          await FirebaseFirestore.instance.collection("Bookmarks").where("PostID", isEqualTo: pics[index]["PostID"]).get().then(
                                            (querySnapshot) {
                                              for (var doc in querySnapshot.docs) {
                                                FirebaseFirestore.instance.collection("Bookmarks").doc(doc.id).delete();
                                              }
                                            }
                                          );
                                          await FirebaseFirestore.instance.collection("Likes").where("PostID", isEqualTo: pics[index]["PostID"]).get().then(
                                            (querySnapshot) {
                                              for (var doc in querySnapshot.docs) {
                                                FirebaseFirestore.instance.collection("Likes").doc(doc.id).delete();
                                              }
                                            }
                                          );

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
                                    // the post card screen acts as a singular post card
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
                                    // rl means resource list and becomes the populated widget list of resources offered by the user
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
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            ListTile(
                                              title: Text('Create a Resource'),
                                              onTap: () {
                                                Navigator.pop(context); // Close the modal bottom sheet
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => ResourceCreationScreen()));
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text('+'),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyResourcesScreen()));
                                },
                                child: Text('My Resources'), // Button labeled "My Resources"
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          // if the user has bookmarked content, this builder creates a scrolling post card list like the feed
                          // built of two future builders, the first grabs the docs and the second creates the list
                          future: FirebaseFirestore.instance.collection("Bookmarks").where("UserID", isEqualTo: UserID).get(),
                          builder: ((BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              dynamic docs = snapshot.data.docs;
                              if (docs.isEmpty) {
                                return Text("No Bookmarks? :(");
                              }
                              // for (var doc in docs) {
                              //   print("Here: ${doc.data() as Map<String, dynamic>}");
                              // }
                              return FutureBuilder(
                                future: bookmarkBuilder(docs),
                                builder: ((BuildContext context, AsyncSnapshot snapshot2) {
                                  if (snapshot2.connectionState == ConnectionState.done && snapshot2.hasData) {
                                    List pics = snapshot2.data;
                                    print(pics);
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
                                          isBookmarked: true,
                                          posterID: pics[index]["Poster"]
                                        );
                                      }
                                    );
                                    
                                  }
                                  else {
                                    return const Center(child:Expanded(child: CircularProgressIndicator()));
                                  }
                                })
                              );
                        
                            }
                            else if (snapshot.hasError) {
                              return Center(child:Text("Bookmarks Snapshot Error"));
                            }
                            else {
                              return const Center(child:Expanded(child: CircularProgressIndicator()));
                            }
                          })),
                        
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
        // this is exactly like any of the other post builder functions, just using bookmarks as the base data
        Future<List> bookmarkBuilder(docs) async {
          dynamic db = FirebaseFirestore.instance;
          List pics = [];
          for (var doc in docs) {
            Map data = doc.data();
            await db.collection("Pictures").doc(data["PostID"]).get().then(
              (DocumentSnapshot doc2) async {
                  Map pic = doc2.data() as Map<String, dynamic>;
                  pic["PostID"] = data["PostID"];
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
// post card screen is a single post card
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
