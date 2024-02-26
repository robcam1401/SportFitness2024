import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:exercise_app/friends.dart';
import 'package:exercise_app/groups.dart';


const LatLng sourceLocation = LatLng(32.53021599903092, -92.65212084047921);


class NearYou extends StatefulWidget{
  @override
  State<NearYou> createState() => _NearYou();
}

class _NearYou extends State<NearYou> {
List<Marker> myMarker = [];

  @override
  // created the google maps widget inside the column so it 
  //would occupy the full space
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Near You'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body:  Column(
        children: [
           Expanded(
            flex: 90,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: sourceLocation, zoom: 14),
              markers: Set.from(myMarker),
              mapType: MapType.normal,
              onTap: _handleTap,
              ),
          ),
                //made a temporary row of two button to show the friends and groups list 
                // pressing the button will switch to those pages
                Row(
                  children: [

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.green,
                        child: ElevatedButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Groups()));},
                          child: const Text("group list"),
                        ),
                      ),
                    ),

                  ],
                )
        ]
              ),
          
          );
  }
          _handleTap(LatLng tappedPoint) {
            print(tappedPoint);
            setState(() {
              myMarker = [];
              myMarker.add(Marker(
                markerId: MarkerId(tappedPoint.toString()),
                position: tappedPoint,
                draggable: true,
                onDragEnd: (DragEndDetails) {
                  print(DragEndDetails);
                }
              ));
            });
          }
      

}