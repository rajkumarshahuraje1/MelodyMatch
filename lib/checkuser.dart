import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodymatch/HomePage.dart';
import 'package:moodymatch/Login.dart';

class CheckUser extends StatelessWidget {
  const CheckUser({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Navigate to the appropriate page based on user authentication
    if (user==null) {
      return  const LoginPage();
    } else {
      return   HomePage();
    }
  }
}
