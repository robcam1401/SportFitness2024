// ignore_for_file: non_constant_identifier_names, use_super_parameters, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_app/other_profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
                      // this boolean checks if the user is the same as the poster
                      // if so, the delete option can be shown
                      if (widget.UserID == widget.posterID) {
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
                    // extra fireabase logic is required to like a post and update in the database
                    db.collection("Likes").add({"PostID" : widget.postID, "UserID" : widget.UserID});
                    db.collection("Pictures").doc(widget.postID).update({"Likes" : widget.likes + 1});
                    widget.likes = widget.likes + 1;
                    widget.isLiked = true;
                  }
                  else {
                    // if the post is already liked and becomes un-liked, remove the like doc in the db and decrement the like counter
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
                      // same logic as the likes, not including an integer counter
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
                    onTap: () {
                      _showCommentSheet();
                    },
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
                                db.collection("Comments").add({"PostID" : widget.postID, "Comment" : commentText, "UserID" : widget.UserID});
                                widget.comments = widget.comments + 1;
                                db.collection("Pictures").doc(widget.postID).update({"Comments" : widget.comments});
                                _commentController.clear();
                                setState(() {});
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
  
  void _showCommentSheet() {
    showModalBottomSheet(
      context: context, 
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
          child: FutureBuilder(
            future: commentBuilder(),
            builder: ((BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Widget> _widgets = snapshot.data;
                print(_widgets.length);
                if (_widgets.isEmpty) {
                  return Expanded(child: Center(child: Text("No Comments? :(")));
                }
                return ListView(children: _widgets);
              }
              else if (snapshot.hasError) {
                return Text("Comment Snapshot Error");
              }
              else {
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              }
            })
          ),
        );
      });
  }
  
  Future<List<Widget>> commentBuilder() async {
    List<Widget> _widgets = [];
    dynamic db = FirebaseFirestore.instance;
    await db.collection("Comments").where("PostID", isEqualTo: widget.postID).get().then(
      (querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          Map data = doc.data() as Map<String, dynamic>;
          await db.collection("UserAccount").doc(data["UserID"]).get().then(
            (DocumentSnapshot doc2) {
              Map data2 = doc2.data() as Map<String, dynamic>;
              Widget cm = Column(
                children: [
                SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "${data2["Username"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " ${data["Comment"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ]),
                  ),
              ]
              );
              // Widget cm = Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.only(
              //     top: 8,
              //   ),
              //   child: RichText(
              //     text: TextSpan(
              //         style: const TextStyle(color: Colors.black),
              //         children: [
              //           TextSpan(
              //             text: data2["Username"],
              //             style: const TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           TextSpan(
              //             text: " ${data["Comment"]}",
              //             style: const TextStyle(
              //               fontWeight: FontWeight.normal,
              //             ),
              //           ),
              //         ]),
              //   ),
              // );
              _widgets.add(cm);
              print(_widgets.length);
            }
          );
        }
        return _widgets;
      }
    );
    return _widgets;
  }
}
