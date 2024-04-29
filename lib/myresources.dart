import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyResourcesScreen extends StatefulWidget {
  @override
  _MyResourcesScreenState createState() => _MyResourcesScreenState();
  //_fetchBookedResources();
}

class _MyResourcesScreenState extends State<MyResourcesScreen> {

  @override
  void initState() {
    super.initState();
  }

  void _loadSampleBookedResources() {
  // Sample data representing booked tennis lessons
  // List<Map<String, dynamic>> sampleData = [
  //   {
  //     'ResourceName': 'Private Tennis Lesson - John',
  //     'Resource_Description': 'One-hour private lesson with Coach John',
  //     'Date_of_Booking': '2024-04-16',
  //   },
  //   {
  //     'ResourceName': 'Group Tennis Clinic',
  //     'Resource_Description': 'Group clinic for intermediate players',
  //     'Date_of_Booking': '2024-04-18',
  //   },
  //   {
  //     'ResourceName': 'Junior Tennis Camp',
  //     'Resource_Description': 'Week-long camp for young tennis enthusiasts',
  //     'Date_of_Booking': '2024-04-20',
  //   },
  // ];

  setState(() {
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Booked Resources'),
      ),
      body: FutureBuilder(
        future: resourceBuilder(),
        builder: ((BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Map<String,dynamic>> _bookedResources = snapshot.data; 
            print(_bookedResources);
            if (_bookedResources.isEmpty) {
              return Center(child: Text('No Resources Booked'));
            }
            else {
              return ListView.builder(
                itemCount: _bookedResources.length,
                itemBuilder: (context, index) {
                Map<String, dynamic> resource = _bookedResources[index];
                return ListTile(
                  title: Text(resource['Name']),
                  subtitle: Text(resource['Description']),
                  trailing: Text('Date: ${resource['Date']}'),
                  // Add more details or customize the ListTile as needed
                );
                },
              );
            }
          }
          else if (snapshot.hasError) {
            return Center(child: Text("My Resource Snapshot Error"));
          }
          else {
            return const Expanded(
                child: Center(
                  child: CircularProgressIndicator()
                  ));
          }
        })
      )
    );
  }
  
  // this method grabs documents in the BookedResources collection that the active user has booked
  Future<List<Map<String,dynamic>>> resourceBuilder() async {
    List<Map<String,dynamic>> _bookedResources = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString("UserID")!;
    dynamic db = FirebaseFirestore.instance;
    // this is information in the booked resource doc
    await db.collection("BookedResources").where("UserID", isEqualTo: UserID).get().then(
      (querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          Map resource = doc.data() as Map<String, dynamic>;
          if (resource["Accepted"]) {
            // this is information in the resource doc
            // this includes the name and description of the resource
            await db.collection("Resources").doc(resource["Resource"]).get().then(
              (DocumentSnapshot doc2) {
                Map resource2 = doc2.data() as Map<String, dynamic>;
                Map<String, dynamic> booked = {
                  "Name" : resource2["Name"],
                  "Description" : resource2["Description"],
                  "Date" : resource["Date"]
                };
                _bookedResources.add(booked);
              }
            );
          }
        }
      }
    );
    return _bookedResources;
  }
}

void main() {
  runApp(MaterialApp(
    home: MyResourcesScreen(),
  ));
}
