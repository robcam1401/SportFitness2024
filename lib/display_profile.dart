import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                                // Handle post tap
                                print('Post tapped: ${post["PostID"]}');
                              },
                              child: Image.network(
                                post['Link'], // Image URL field from Firestore
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      // Resources Tab
                      Center(
                        child: Text('Resources Tab Content'),
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
