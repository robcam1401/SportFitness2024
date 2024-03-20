import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Future<void> _launchPayPalWebsite() async {
    const String url = 'https://www.paypal.com'; // URL for PayPal login page

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchPayPalWebsite, // Launch PayPal website when button is pressed
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('Open PayPal'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CheckoutPage(),
  ));
}
