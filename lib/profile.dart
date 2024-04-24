// ignore_for_file: prefer_const_constructors
import 'package:exercise_app/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'lesson_booking_page.dart';
import 'video_analysis_page.dart';
import 'resource.dart';
import 'myresources.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserData(); // Call method to fetch username when the state is initialized
  }
  String userName = ''; 
  String fullName = ''; 
  String bio = ''; 
  int followers = 0;
  int following = 0;
  Future<void> _fetchUserData() async {
    // Access Firestore collection 'users' and document with userID (e.g., 'myAccountNumber')
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('UserAccount')
          .doc('vq5eKKU3grdnIcQrUE47') 
          .get();

      if (userSnapshot.exists) {
        setState(() {
          userName = userSnapshot['Username']; 
          fullName = userSnapshot['FullName']; 
          bio = userSnapshot['Biography']; 
          followers = userSnapshot['Followers']; 
          following = userSnapshot['Following'];
        });
      } else {
        // Handle scenario where user document does not exist
        if (kDebugMode) {
          print('User document not found');
        }
      }
    } catch (e) {
      // Handle any potential errors with fetching data
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
    }
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
      const AssetImage('assets/Images/post_image1.jpg'),
      // Add more post images as needed
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Notifications()));
            },
            icon: const Icon(Icons.add_alert_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 20), // Adding space for better alignment
              const CircleAvatar(
                radius: 40,
                // Your profile picture
                backgroundImage: AssetImage('assets/Images/profile_picture.jpg'),
              ),
              const SizedBox(width: 20), // Adding space between bio and counts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Following:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        following.toString(), // Your following count
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Followers:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        followers.toString(), // Your following count
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
          const SizedBox(width: 20), // Adding space between profile picture and name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\t\t$userName',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '\t\tBio:$bio',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            tabs: const [
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                              profilePicture: const AssetImage('assets/Images/profile_picture.jpg'),
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
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
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: resources.map((resource) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListTile(
                                title: Text(
                                  resource.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                subtitle: Text(
                                  resource.description, // Assuming description exists in your Resource class
                                ),
                                trailing: ElevatedButton(
                                  onPressed: resource.onPressed,
                                  child: const Text('Select'),
                                ),
                              ),
                              const Divider(), 
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
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
                                      title: const Text('Create a Resource'),
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
                        child: const Text('+'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyResourcesScreen()));
                        },
                        child: const Text('My Resources'), // Button labeled "My Resources"
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  const PostCardScreen({super.key, 
    required this.image,
    required this.name,
    required this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
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
                            style: const TextStyle(
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
                    icon: const Icon(Icons.more_vert),
                  ),
                  // Add more widgets here if necessary
                ],
              ),
            ),
            // Image Section
            SizedBox(
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
                  icon: const Icon(
                    Icons.thumb_up,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.comment_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border),
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
                        .titleSmall!
                        .copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    child: Text(
                      '509 likes',
                      style: Theme.of(context).textTheme.bodyMedium,
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
                          const TextSpan(
                            text: ' Great day to play some tennis!',
                            style: TextStyle(
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
                      child: const Text(
                        'View all 5 comments',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text(
                      '2/25/2024',
                      style: TextStyle(
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
