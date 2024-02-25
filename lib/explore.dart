import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng sourceLocation = LatLng(32.53021599903092, -92.65212084047921);


class Explore extends StatefulWidget{
  @override
  State<Explore> createState() => _Explore();
}

class _Explore extends State<Explore> {
  @override
  // blank page to contain the code for the explore page

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Explore'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
    );
  }
}