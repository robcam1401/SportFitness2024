import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lesson_booking_page.dart';
import 'post_card.dart';
import 'resource.dart';
import 'myresources.dart';

class DisplayProfile extends StatefulWidget {
  final String id;
  DisplayProfile({required this.id});
  @override
  _DisplayProfileState createState() => _DisplayProfileState();
}

class _DisplayProfileState extends State<DisplayProfile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<Map<String, dynamic>> _userDataFuture;
  late Future<void> _userPostsFuture; // Change type to Future<void>
  late List<Map<String, dynamic>> _pics = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _userDataFuture = _fetchUserData();
    _userPostsFuture = _fetchUserPosts(); // Assign Future<void> to _userPostsFuture
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection("UserAccount").doc(widget.id).get();
      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        print('User document does not exist');
        return {};
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {};
    }
  }

  Future<void> _fetchUserPosts() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("Pictures")
          .where("Poster", isEqualTo: widget.id)
          .get();

      _pics = await postCardBuilder(querySnapshot.docs); // Update _pics with fetched data
      setState(() {}); // Trigger rebuild after updating _pics
    } catch (e) {
      print('Error fetching user posts: $e');
    }
  }

  Future<List<Map<String, dynamic>>> postCardBuilder(List<DocumentSnapshot> docs) async {
    List<Map<String, dynamic>> pics = [];

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      String postID = doc.id;
      data["PostID"] = postID;

      // Retrieve additional fields from Firestore
      data["Comments"] = await _fetchComments(postID);
      data["Likes"] = await _fetchLikes(postID);

      pics.add(data);
    }

    return pics;
  }

  Future<int> _fetchLikes(String postID) async {
    var querySnapshot = await FirebaseFirestore.instance.collection("Likes").where("PostID", isEqualTo: postID).get();
    return querySnapshot.docs.length;
  }

  Future<int> _fetchComments(String postID) async {
    var querySnapshot = await FirebaseFirestore.instance.collection("Comments").where("PostID", isEqualTo: postID).get();
    return querySnapshot.docs.length;
  }

  Future<List<Resource>> buildResources(String userID) async {
  List<Resource> resources = [];

  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Resources")
        .where("UserID", isEqualTo: userID)
        .get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> resourceData = doc.data() as Map<String, dynamic>;
      Resource rc = Resource(
        id: doc.id,
        name: resourceData["Name"],
        description: resourceData["Description"],
        available: true,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonBookingPage(
                name: resourceData["Name"],
                resourceID: doc.id,
                numPlayers: resourceData["PeopleAmount"],
                bookDate: resourceData["Date"],
                duration: resourceData["HoursAmount"],
                priceHour: resourceData["PriceHour"],
                pricePerson: resourceData["PricePerson"],
              ),
            ),
          );
        },
      );
      resources.add(rc);
    }
  } catch (e) {
    print('Error fetching resources: $e');
  }

  if (resources.isEmpty) {
    // Create a temporary example resource for visualization
    Resource exampleResource = Resource(
      id: '1',
      name: 'Private Lessons',
      description: 'Offered from Monday to Sunday! Click for pricing, availability, and more.',
      available: true,
      onPressed: () {
        // Implement onPressed behavior for the example resource if needed
      },
    );
    resources.add(exampleResource);
  }

  return resources;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _userDataFuture,
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error');
            } else {
              var userData = snapshot.data ?? {};
              var username = userData["Username"] ?? '';
              return Text(username);
            }
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: _userDataFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var userData = snapshot.data ?? {};
            var profilePicture = userData["ProfilePicture"] ?? '';
            var fullName = userData["FullName"] ?? '';
            var username = userData["Username"] ?? '';
            var biography = userData["Biography"] ?? '';
            var followingCount = userData["Following"] ?? 0;
            var followerCount = userData["Followers"] ?? 0;
            var website = userData["Website"] ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(profilePicture),
                ),
                SizedBox(height: 2),
                Text(
                  fullName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  '@$username',
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
                          itemCount: _pics.length,
                          itemBuilder: (BuildContext context, int index) {
                            var post = _pics[index];
                            print('Post at index $index: $post');
                            return GestureDetector(
                              onTap: () {
                                print('Post tapped: ${post["PostID"]}');

                                // Navigate to PostCardScreen with post details
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostCardScreen(
                                      postUrl: post["Link"] ?? '',
                                      userImage: post["ProfilePicture"] ?? '',
                                      description: post["Description"] ?? '',
                                      username: post["Username"] ?? '',
                                      likes: post["Likes"] ?? 0,
                                      comments: post["Comments"] ?? 0,
                                      timestamp: post["UploadDate"] ?? Timestamp.now(),
                                      UserID: widget.id,
                                      postID: post["PostID"] ?? '',
                                      isLiked: post["isLiked"] ?? false,
                                      isBookmarked: true, // Assuming this should be set based on logic
                                      posterID: post["Poster"] ?? '',
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                post['Link'] ?? '', // Image URL field from Firestore
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      // Resources Tab
                      Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              FutureBuilder(
                                future: buildResources("UserID"),
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
                              
                            ],
                          ),
                        ),
            
                    ],
                  ),
                ),
              ],
            );
          }
        },
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
