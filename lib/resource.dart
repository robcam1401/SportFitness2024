import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResourceCreationScreen extends StatefulWidget {
  @override
  _ResourceCreationScreenState createState() => _ResourceCreationScreenState();
}

class _ResourceCreationScreenState extends State<ResourceCreationScreen> {
  TextEditingController _resourceNameController = TextEditingController();
  TextEditingController _resourceDescriptionController =
      TextEditingController();
  List<String> _selectedPrompts = [];
  List<String> _promptOptions = [
    'Number of People',
    'Number of Hours',
    'Date of Booking',
    'Payment Option',
    'File Upload',
    'Calendar'
  ];
  // disables the submit button until all forms have been filled
  bool _isButtonEnabled = false;
  // booking limit represents the amount of times a specific resource can be booked
  int bookingLimit = 0;
  int pricePerson = 0;
  int priceHour = 0;
  DateTime? _selectedDate;

  void _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  @override
  void initState() {
    super.initState();
    _resourceNameController.addListener(_checkButtonEnable);
  }

  void _checkButtonEnable() {
    setState(() {
      _isButtonEnabled = _resourceNameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Resource'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resource Name:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _resourceNameController,
                decoration: InputDecoration(
                  hintText: 'Enter resource name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Resource Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _resourceDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter resource description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Booking Limit:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: DropdownButton<int>(
                  value: bookingLimit,
                  onChanged: (value) {
                    setState(() {
                      bookingLimit = value!;
                    });
                  },
                  items: [0, 1, 2, 3, 4, 5]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Select Prompts:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _promptOptions.length,
                itemBuilder: (context, index) {
                  final prompt = _promptOptions[index];
                  return CheckboxListTile(
                    title: Text(prompt),
                    value: _selectedPrompts.contains(prompt),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedPrompts.add(prompt);
                          if (prompt == 'Calendar') {
                            _presentDatePicker(); // Call this method when 'Calendar' is added
                          }
                        } else {
                          _selectedPrompts.remove(prompt);
                        }
                      });
                    },
                  );
                },
              ),

              SizedBox(height: 16),
              Text(
                'Price per Person:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: DropdownButton<int>(
                  value: pricePerson,
                  onChanged: (value) {
                    setState(() {
                      pricePerson = value!;
                    });
                  },
                  items: [0, 1, 2, 3, 4, 5]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Price per Hour:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: DropdownButton<int>(
                  value: priceHour,
                  onChanged: (value) {
                    setState(() {
                      priceHour = value!;
                    });
                  },
                  items: [0, 1, 2, 3, 4, 5]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 20),
              _buildCreatedResourceCard(), // Display created resource if available
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _createResource : null,
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatedResourceCard() {
    if (_resourceNameController.text.isNotEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Created Resource:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Name: ${_resourceNameController.text}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${_resourceDescriptionController.text}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Prompts: ${_selectedPrompts.join(", ")}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(); // Return an empty container if no resource is created yet
    }
  }

  void _createResource() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString("UserID")!;

    // Extract data from controllers and selected prompts
    String resourceName = _resourceNameController.text;
    String resourceDescription = _resourceDescriptionController.text;
    bool peopleAmount =
        _selectedPrompts.contains('Number of People') ? true : false;
    bool hoursAmount =
        _selectedPrompts.contains('Number of Hours') ? true : false;
    bool dateOfBooking =
        _selectedPrompts.contains('Date of Booking') ? true : false;
    bool payment = _selectedPrompts.contains('Payment Option') ? true : false;
    bool fileUpload = _selectedPrompts.contains('File Upload') ? true : false;

    // Create the dictionary (Map)
    Map<String, dynamic> resourceData = {
      'UserID': UserID,
      'Name': resourceName,
      'Description': resourceDescription,
      'PeopleAmount': peopleAmount,
      'HoursAmount': hoursAmount,
      'Date': dateOfBooking,
      'Payment': payment,
      'FileUpload': fileUpload,
      'isBooked': false,
      'BookingLimit': bookingLimit,
      'PricePerson': pricePerson,
      'PriceHour': priceHour,
      'CalendarDate': _selectedDate?.toIso8601String(),
    };

    // Call the function to send the resource data to the server
    dynamic db = FirebaseFirestore.instance;
    db.collection("Resources").add(resourceData).then((documentSnapshot) {
      print("Resource Added");
      // go back to the profile page
      Navigator.pop(context, resourceData);
    });
  }

  @override
  void dispose() {
    _resourceNameController.dispose();
    _resourceDescriptionController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: ResourceCreationScreen(),
  ));
}