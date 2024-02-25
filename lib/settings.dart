import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng sourceLocation = LatLng(32.53021599903092, -92.65212084047921);


class Settings extends StatefulWidget{
  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  // blank page to contain the code for the setings page

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
    );
  }
}