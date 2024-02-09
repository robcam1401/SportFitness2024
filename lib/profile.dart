import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng sourceLocation = LatLng(32.53021599903092, -92.65212084047921);


class Profile extends StatefulWidget{
  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  // blank page to contain the code for the profile page

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
    );
  }
}