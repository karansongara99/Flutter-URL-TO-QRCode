import 'dart:async';
import 'package:flutter/material.dart';
import './QRCodeScreen.dart'; // Change to your actual screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QRCodeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Adjust padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/qr.jpg',
                width: MediaQuery.of(context).size.width * 0.6, // Responsive sizing
              ),
              SizedBox(height: 8),
              Text(
                'Welcome to URL To QR Code', // Change text as needed
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(), // Optional loading indicator
            ],
          ),
        ),
      ),
    );
  }
}
