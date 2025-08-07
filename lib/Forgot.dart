import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodymatch/Login.dart';
import 'Uihelper.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final TextEditingController forgotController = TextEditingController();

  String? validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      Uihelper.CustomAlertBox(context, "Enter a valid email");
      return "Invalid email";
    }
    return null;
  }

  Future<void> sendResetEmail(String email) async {
    if (validateEmail(email) != null) {
      return; // Stop execution if email is invalid
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Password reset link sent to your email."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (ex) {
      print("Error: ${ex.code} - ${ex.message}");
      Uihelper.CustomAlertBox(context, ex.message ?? "An error occurred");
    } catch (e) {
      print("Unexpected error: $e");
      Uihelper.CustomAlertBox(context, "An unexpected error occurred.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Input Field
            TextField(
              controller: forgotController,
              decoration: InputDecoration(
                hintText: "Enter Registered Email ID",
                suffixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // Custom Styled Elevated Button
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  sendResetEmail(forgotController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
