import 'package:flutter/material.dart';
import 'checkuser.dart';
import 'dart:async'; // For splash screen timer


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home screen after 1 seconds
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CheckUser()), // Replace with your home screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular avatar for the logo
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/melody1.jpeg'), // Add your logo in assets folder
              radius: 60, // Adjust size of the avatar
              backgroundColor: Colors.white, // Optional white border
            ),
            const SizedBox(height: 20), // Spacing between logo and app name
            // App name
            const Text(
              'Melody Match',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
