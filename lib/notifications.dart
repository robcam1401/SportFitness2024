import 'faq_page.dart';
import 'package:exercise_app/loginScreen.dart';
import 'package:flutter/material.dart';
import 'profile_settings.dart';
import 'account_settings.dart';
import 'package:url_launcher/url_launcher.dart';

// String encodeQueryParameters(Map<String, String> params) {
//   return params.entries
//       .map((e) =>
//           '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
//       .join('&');
// }



  
class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Notifications(),
//   ));
// }
