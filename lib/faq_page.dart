import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Q1: How do I update my profile?',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Answer: You can update your profile by going to the Profile Settings page.'),
            SizedBox(height: 20),
            Text('Q2: How do I change my password?',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Answer: You can change your password from the Account Settings page.'),
            // Add more questions and answers here
          ],
        ),
      ),
    );
  }
}
