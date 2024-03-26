import 'package:exercise_app/friends.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:exercise_app/post_card.dart';

const LatLng sourceLocation = LatLng(32.53021599903092, -92.65212084047921);

class Feed extends StatefulWidget {
  @override
  State<Feed> createState() => _Feed();
}

class _Feed extends State<Feed> {
  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // to make background transparent
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Create new post',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        size: 50,
                        color: Colors.grey[800],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Drag photos and videos here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      ElevatedButton(
                        child: Text(
                          'Select from your device',
                          style: TextStyle(
                            color: Colors.white, // Text color
                          ),
                        ),
                        onPressed: () {
                          // Logic to pick the image
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors
                              .white, backgroundColor: Colors.red[600], // Text color for the ElevatedButton style
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness & Sports App',
            style: TextStyle(
              fontFamily: 'DancingScript',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 241, 241),
            )),
        actions: [
          IconButton(
            onPressed: _showUploadSheet,
            icon: Icon(Icons.add_box_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Friends()));
            },
            icon: Icon(Icons.messenger_outline),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: ListView.builder(
        itemCount: userImagesUrls.length,
        itemBuilder: (context, index) {
          return PostCard(
            userImagesUrls: userImagesUrls[index % userImagesUrls.length],
            posts: posts[index % posts.length],
          );
        },
      ),
    );
  }
}
