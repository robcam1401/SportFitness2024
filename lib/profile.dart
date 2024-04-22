import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lesson_booking_page.dart';
import 'video_analysis_page.dart';
import 'post_card.dart';
import 'dart:convert';
import 'dbInterface.dart';
import 'resource.dart';
import 'myresources.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userName = '';
  String? UserID = ''; // Replace with actual account number
  int followingCount = 0;
  int followerCount = 0;
  String profilePicture = '';
  String biography = '';
  List pics = [];
  List<Map<String, dynamic>> _bookedResources = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<String> fetchUserInfo() async {
    dynamic db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserID = prefs.getString("UserID");
    await db.collection("UserAccount").doc(UserID).get().then(
      (DocumentSnapshot doc) {
        Map data = doc.data() as Map<String, dynamic>;
        print("Profile Info: $data");
        userName = data["Username"];
        followerCount = data["Followers"];
        followingCount = data["Following"];
        profilePicture = data["ProfilePicture"];
        biography = data["Biography"];
        return ("Profile Completed");
      }
    );
    await db.collection("Pictures").where("Poster", isEqualTo: UserID).get().then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          db.collection("Pictures").doc(doc.id).get().then(
            (DocumentSnapshot doc2) {
              pics.add(doc2.data() as Map<String, dynamic>); 
            }
          );
        }
      }
    );
    return ("Profile Loading");
  }


  @override
    Widget build(BuildContext context) {
      List<Resource> resources = [
        Resource(
          id: '1',
          name: 'Private Lessons',
          description: 'Personalised tennis sessions to up to 3 players! Work on your shot teqnique, feet movement, strategy...',
          available: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LessonBookingPage()));
          },
        ),
        Resource(
          id: '2',
          name: 'Video Analysis',
          description: 'Personalised Video Anlaysis...',
          available: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoAnalysisPage()));
          },
        ),
        // Add more resources as needed
      ];

      List<ImageProvider> postImages = [
        AssetImage('assets/Images/post_image1.jpg'),
        // Add more post images as needed
      ];

      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          backgroundColor: Colors.blue,
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
                          itemCount: postImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostCardScreen(
                                      image: postImages[index],
                                      name: 'Ilana Tetruashvili',
                                      profilePicture: AssetImage('assets/Images/profile_picture.jpg'),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 200, // Adjust width as needed
                                height: 200, // Adjust height as needed
                                child: Image(
                                  image: postImages[index],
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
                              Column(
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
                      ],
                    ),
                  ),
                ],
              );
              return pc;
            }
            else {
              return CircularProgressIndicator();
            }
            
          })
        )
      );
    }
    
    fetchUser() async {
      dynamic db = FirebaseFirestore.instance;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserID = prefs.getString("UserID");
      await db.collection("UserAccount").doc(UserID).get().then(
        (DocumentSnapshot doc) {
          Map data = doc.data() as Map<String, dynamic>;
          print("Profile Info: $data");
          userName = data["Username"];
          followerCount = data["Followers"];
          followingCount = data["Following"];
          profilePicture = data["ProfilePicture"];
          biography = data["Biography"];
          return ("Profile Completed");
        }
      );
    return ("Profile Loading");
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

class PostCardScreen extends StatelessWidget {
  final ImageProvider image;
  final String name;
  final ImageProvider profilePicture;

  const PostCardScreen({
    required this.image,
    required this.name,
    required this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: profilePicture,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Add more children here if necessary
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.more_vert),
                  ),
                  // Add more widgets here if necessary
                ],
              ),
            ),
            // Image Section
            Container(
              height: MediaQuery.of(context).size.height * 0.50,
              width: double.infinity,
              child: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
            // Like, Comment, and Share section
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.thumb_up,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.comment_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),

            // Caption and number of comments
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    child: Text(
                      '509 likes',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' Great day to play some tennis!',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all 5 comments',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '2/25/2024',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
