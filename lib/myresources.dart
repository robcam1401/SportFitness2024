import 'package:flutter/material.dart';

class MyResourcesScreen extends StatefulWidget {
  @override
  _MyResourcesScreenState createState() => _MyResourcesScreenState();
  //_fetchBookedResources();
}

class _MyResourcesScreenState extends State<MyResourcesScreen> {

  //code for fetching the resources
  //void _fetchBookedResources() async {
  //  String accountNumber = '1'; // Replace with actual account number

    // Call the function to fetch booked resources from the server
   // List<dynamic> response = await Query().get_booked_resources(accountNumber);
  //  setState(() {
  //    _bookedResources = List<Map<String, dynamic>>.from(response);
  //  });
  //}

  List<Map<String, dynamic>> _bookedResources = [];
  @override
  void initState() {
    super.initState();
    _loadSampleBookedResources(); // Load sample data
  }

  void _loadSampleBookedResources() {
  // Sample data representing booked tennis lessons
  List<Map<String, dynamic>> sampleData = [
    {
      'ResourceName': 'Private Tennis Lesson - John',
      'Resource_Description': 'One-hour private lesson with Coach John',
      'Date_of_Booking': '2024-04-16',
    },
    {
      'ResourceName': 'Group Tennis Clinic',
      'Resource_Description': 'Group clinic for intermediate players',
      'Date_of_Booking': '2024-04-18',
    },
    {
      'ResourceName': 'Junior Tennis Camp',
      'Resource_Description': 'Week-long camp for young tennis enthusiasts',
      'Date_of_Booking': '2024-04-20',
    },
  ];

  setState(() {
    _bookedResources = List<Map<String, dynamic>>.from(sampleData);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Booked Resources'),
      ),
      body: _bookedResources.isEmpty
          ? Center(
              child: Text('No resources booked.'),
            )
          : ListView.builder(
              itemCount: _bookedResources.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> resource = _bookedResources[index];
                return ListTile(
                  title: Text(resource['ResourceName']),
                  subtitle: Text(resource['Resource_Description']),
                  trailing: Text('Date: ${resource['Date_of_Booking']}'),
                  // Add more details or customize the ListTile as needed
                );
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyResourcesScreen(),
  ));
}
