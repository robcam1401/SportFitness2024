import 'package:flutter/material.dart';

class ResourceCreationScreen extends StatefulWidget {
  @override
  _ResourceCreationScreenState createState() => _ResourceCreationScreenState();
}

class _ResourceCreationScreenState extends State<ResourceCreationScreen> {
  TextEditingController _resourceNameController = TextEditingController();
  TextEditingController _resourceDescriptionController = TextEditingController();
  List<String> _selectedPrompts = [];
  List<String> _promptOptions = ['Number of People', 'Number of Hours', 'Date of Booking', 'Payment Option', 'File Upload'];
  bool _isButtonEnabled = false;

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
                        if (value!) {
                          _selectedPrompts.add(prompt);
                        } else {
                          _selectedPrompts.remove(prompt);
                        }
                      });
                    },
                  );
                },
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

  void _createResource() {
    // Handle resource creation logic here
    // For example, you can save the resource to a database
    // You can also save _selectedPrompts along with the resource
    // For demonstration purposes, we're just popping the screen
    Navigator.pop(context); // Return to previous screen
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
