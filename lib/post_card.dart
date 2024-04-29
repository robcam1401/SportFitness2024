import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/other_profile.dart';
import 'package:exercise_app/profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
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

  PostCard({
    Key? key,
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
  }) : super(key: key);

  

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool showComments = false; //boolean for comment state
  //bool isLiked = false; //boolean variable for like state
  List userInfo = [];
  TextEditingController _commentController = TextEditingController();

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.userImage),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
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
                    onPressed: () async {
                      if (widget.UserID == widget.posterID) {
                        print("True");
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
                                  child: Container(
                                    height: 50,
                                    child: const Center (child: Text('Delete'))
                                  ),
                                ),
                                
                              ]
                            ),
                          ),
                        );
                      }
                      else {
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
                                onTap: () {Navigator.of(context).pop();Navigator.push(context, MaterialPageRoute(builder: (context)=>otherProfile(posterID: widget.posterID)));},
                                child: Container(
                                  height: 50,
                                  child: const Center(child: Text('Profile')),
                                ),
                              )
                            ]
                          ),
                        ),
                      );
                      }
                      
                    },

                    icon: Icon(Icons.more_vert)),
                // Add more widgets here if necessary
              ],
            ),
          ),
          //Image Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.postUrl,
              fit: BoxFit.cover,
            ),
          ),
          // Like Comment and Share section
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  dynamic db = FirebaseFirestore.instance;
                  if (!widget.isLiked){
                    db.collection("Likes").add({"PostID" : widget.postID, "UserID" : widget.UserID});
                    db.collection("Pictures").doc(widget.postID).update({"Likes" : widget.likes + 1});
                    widget.likes = widget.likes + 1;
                    widget.isLiked = true;
                  }
                  else {
                    await db.collection("Likes").where("PostID", isEqualTo: widget.postID).where("UserID", isEqualTo: widget.UserID).get().then(
                      (querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          db.collection("Likes").doc(doc.id).delete();
                        }
                      }
                    );
                    db.collection("Pictures").doc(widget.postID).update({"Likes" : widget.likes - 1});
                    widget.likes = widget.likes - 1;
                    widget.isLiked = false;
                  }
                  setState(() {
                  });
                },
                icon: Icon(
                  Icons.thumb_up,
                  color: widget.isLiked ? Colors.blue : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showComments = !showComments;
                  });
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {Share.share('check out my website https://example.com');},
                icon: const Icon(Icons.send,),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.bookmark_border, color: widget.isBookmarked ? Colors.blue : Colors.grey),
                    onPressed: () async {
                      dynamic db = FirebaseFirestore.instance;
                      if (!widget.isBookmarked){
                        db.collection("Bookmarks").add({"PostID" : widget.postID, "UserID" : widget.UserID});
                        widget.isBookmarked = true;
                      }
                      else {
                        await db.collection("Bookmarks").where("PostID", isEqualTo: widget.postID).where("UserID", isEqualTo: widget.UserID).get().then(
                          (querySnapshot) {
                            for (var doc in querySnapshot.docs) {
                              db.collection("Bookmarks").doc(doc.id).delete();
                            }
                          }
                        );
                        widget.isBookmarked = false;
                      }
                      setState(() {
                      });
                  },
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
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    child: Text(
                      "${widget.likes}",
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
                              text: widget.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " ${widget.description}",
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        // the number of comments are stored in posts[i][Comments]
                        'View all ${widget.comments} comments',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      // the upload date is stored in posts[i][UploadDate]
                      "${widget.timestamp.toDate()}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  if (showComments)
                    Column(
                      children: [
                        TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            labelText: 'Write a comment...',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                final commentText = _commentController.text;
                                // Here, you'd  send the comment to your backend or handle it as needed
                                dynamic db = FirebaseFirestore.instance;
                                db.collection("Comments").add({"PostID" : widget.postID, "Comment" : commentText});
                                widget.comments = widget.comments + 1;
                                db.collection("Pictures").doc(widget.postID).update({"Comments" : widget.comments});
                                _commentController.clear();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
