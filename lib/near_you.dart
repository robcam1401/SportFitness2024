import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class NearYou extends StatefulWidget {
  @override
  NearYouState createState() => NearYouState();
}

class NearYouState extends State<NearYou> {
  Completer<GoogleMapController> _controller = Completer();
  late Position _currentPosition;
  Set<Marker> markersNearby = {};
  double thresholdDistance = 80467; // Initial threshold distance


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    requestLocationPermission();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      print(position);
      _currentPosition = position;
    });
    checkNearbyMarkers(position);
  }

  double distanceBetween(Position pos1, LatLng pos2) {
    return Geolocator.distanceBetween(pos1.latitude, pos1.longitude,
        pos2.latitude, pos2.longitude);
  }

 void checkNearbyMarkers(Position userLocation) {
  Set<Marker> newMarkers = {};
  for (Marker marker in [
    gramercyMarker,
    bernardinMarker,
    blueMarker,
    powerMarker
  ]) {
    double distance = distanceBetween(userLocation, marker.position);
    if (distance <= thresholdDistance) {
      newMarkers.add(marker);
    }
  }
  // Update markersNearby with the new set of markers
  setState(() {
    markersNearby = newMarkers;
  });
}

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(32.53070986780426,
                  -92.65166205089903), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(32.53070986780426,
                  -92.65166205089903), zoom: zoomVal)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(""),
        actions: [
          IconButton(
            onPressed: () {
              setState((){});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
          _buildContainer(),
          _buildThresholdSlider(), // New slider widget

        ],
      ),
    );
  }

  Widget _zoomminusfunction() {
    return Align();
  }

  Widget _zoomplusfunction() {
    return Align();
  }

Widget _buildThresholdSlider() {
  return Container(
        child: FittedBox(
            child:
     Align(
      alignment: Alignment.topCenter,
      child: Slider(
        value: thresholdDistance,
        activeColor: Colors.black,
        min: 0, // Minimum threshold distance
        max: 80467, // Maximum threshold distance
        divisions: 10,
        label: ((0.621*.001*thresholdDistance).round()).toString(),
        onChanged: (double value) {
          setState(() {
            thresholdDistance = value;
          });
          // Move checkNearbyMarkers outside of setState
          checkNearbyMarkers(_currentPosition);
        },
      ),
    ),
    ));
}

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlmAd2R0GFoEGTJgpYGRrZQa5SWURczrDUtg&s",
                  32.52955279123997, -92.71635044424062,
                  "5k Run"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/fitness-competition-design-template-25dc8113019ab96a17c6d07d771e66bc_screen.jpg?ts=1637013383",
                  32.50636157319903, -92.15050190014296,
                  "Fitness Competition"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/event-poster-fitness-club-design-template-244dfd5ed622161bf5d1df0a7520a875_screen.jpg?ts=1645433908",
                  32.5057384467211,
                  -92.63482201512295,
                  "Fitness Club"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGKyf4nB-VLwNbE79ySmR6UHlNG6m8awwg0Q&s",
                  32.545690522365746,
                  -92.61870027903757,
                  "Power Lifting Club"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String _image, double lat, double long, String eventName) {
    LatLng pos = LatLng(lat,long);
    double distance = distanceBetween(_currentPosition, pos);
    if(distance > thresholdDistance){
      return SizedBox.shrink(); // If marker is not within threshold, render an empty SizedBox

    };
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: FittedBox(
            child: Material(
                color: Colors.white,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Color(0x802196F3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 180,
                      height: 200,
                      child: ClipRRect(
                          borderRadius: new BorderRadius.circular(24.0),
                          child: Image.network(_image)),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: myDetailsContainer1(eventName),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  Widget myDetailsContainer1(String eventName) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Text(
          eventName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
          ),
        )),
      ),
    ]);
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: positionToLatLng(_currentPosition), zoom: 10),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markersNearby,
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      bearing: 45.0,
    )));
  }
}

Marker gramercyMarker = Marker(
  markerId: MarkerId('5k Run'),
  position: LatLng(32.52955279123997, -92.71635044424062),
  infoWindow: InfoWindow(title: '5K run'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker bernardinMarker = Marker(
  markerId: MarkerId('Fitness Competition'),
  position: LatLng(32.533464322282775, -92.65099924429194),
  infoWindow: InfoWindow(title: 'Fitness Competition'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
Marker blueMarker = Marker(
  markerId: MarkerId('Fitness Club'),
  position: LatLng(32.50636157319903, -92.15050190014296),
  infoWindow: InfoWindow(title: 'Fitness CLub'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker powerMarker = Marker(
  markerId: MarkerId('Power Lifting Club'),
  position: LatLng(32.545690522365746, -92.61870027903757),
  infoWindow: InfoWindow(title: 'Power Lifting CLub'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);


  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted
    } else if (status.isDenied) {
      // Permission denied
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, navigate to app settings
      openAppSettings();
    }
  }

  LatLng positionToLatLng(Position position) {
  return LatLng(position.latitude, position.longitude);
}

Position latLngToPosition(LatLng latLng) {
  return Position(
    latitude: latLng.latitude,
    longitude: latLng.longitude,
    timestamp: DateTime.now(),
    altitude: 0.0,
    accuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    heading: 0.0, 
    altitudeAccuracy: 0.0, 
    headingAccuracy: 0.0,
  );
}
