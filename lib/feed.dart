import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng sourceLocation = LatLng(32.53021599903092, -92.65212084047921);


class Feed extends StatefulWidget{
  @override
  State<Feed> createState() => _Feed();
}

class _Feed extends State<Feed> {
  @override
// blank page to contain the code for the feed page
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Feed'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
    );
  }
}