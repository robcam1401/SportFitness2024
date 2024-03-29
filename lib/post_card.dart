import 'package:exercise_app/other_profile.dart';
import 'package:exercise_app/profile.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter/material.dart';

final List<String> userImagesUrls = [
  'http://www.dumpaday.com/wp-content/uploads/2017/01/random-pictures-109.jpg',
  'http://www.dumpaday.com/wp-content/uploads/2017/01/random-pictures-109.jpg',
  'http://www.dumpaday.com/wp-content/uploads/2017/01/random-pictures-109.jpg',
  'http://www.dumpaday.com/wp-content/uploads/2017/01/random-pictures-109.jpg',
];

final List<String> posts = [
  'https://tse1.mm.bing.net/th?id=OIP.fOrOyNQkXAfA6-tqSe0rwgHaEo&pid=Api&P=0&h=180',
  'https://tse1.mm.bing.net/th?id=OIP.fOrOyNQkXAfA6-tqSe0rwgHaEo&pid=Api&P=0&h=180',
  'https://tse1.mm.bing.net/th?id=OIP.fOrOyNQkXAfA6-tqSe0rwgHaEo&pid=Api&P=0&h=180',
  'https://tse1.mm.bing.net/th?id=OIP.fOrOyNQkXAfA6-tqSe0rwgHaEo&pid=Api&P=0&h=180',
];

class PostCard extends StatefulWidget {
  final String userImagesUrls;
  final String posts;
  final String text = "hello";

  const PostCard({
    Key? key,
    required this.userImagesUrls,
    required this.posts,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool showComments = false; //boolean for comment state
  bool isLiked = false; //boolean variable for like state
  TextEditingController _commentController = TextEditingController();

  @override
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
                  backgroundImage: NetworkImage(widget.userImagesUrls),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
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
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  height: 50,
                                  child: const Center (child: Text('Delete'))
                                ),
                              ),
                              InkWell(
                                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>otherProfile()));},
                                child: Container(
                                  height: 50,
                                  child: const Center(child: Text('Profile')),
                                ),
                              )
                            ]
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.more_vert)),
                // Add more widgets here if necessary
              ],
            ),
          ),
          //Image Section
          /*SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              posts,
              fit: BoxFit.cover,
            ),
          ),*/
          // Like Comment and Share section
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                icon: Icon(
                  Icons.thumb_up,
                  color: isLiked ? Colors.blue : Colors.grey,
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
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
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
                              text: 'Username',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' Just a grey Color for now !!!',
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
                        'View all 5 comments',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '2/25/2024',
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
                                print(
                                    'Comment: $commentText'); // For demonstration only
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
