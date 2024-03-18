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
  @override
// blank page to contain the code for the feed page
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness & Sports App',
            style: TextStyle(
              fontFamily: 'DancingScript',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 241, 241),
            )),
        //title: Image.asset('assets/Images/OurLogo.png', width: 90, height: 50),
        actions: [
          IconButton(
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Friends()));},
            icon: Icon(
              Icons.messenger_outline,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: ListView.builder(
        itemCount: userImagesUrls.length, // Number of PostCards you want
        itemBuilder: (context, index) {
          // Assuming you have the same number of userImageUrls and posts
          // and you want to cycle through them
          return PostCard(
            userImagesUrls: userImagesUrls[index % userImagesUrls.length],
            posts: posts[index % posts.length],
          );
        },
      ),
    );
  }
}
