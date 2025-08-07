import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodymatch/HomePage.dart';
import 'package:moodymatch/Login.dart';
import 'package:moodymatch/Uihelper.dart';
import 'package:moodymatch/password.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  String? validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      Uihelper.CustomAlertBox(context, "Enter a valid email");
      return "Invalid email";
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 6) {
      Uihelper.CustomAlertBox(context, "Password must be at least 6 characters");
      return "Password too short";
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Uihelper.CustomAlertBox(context, "Please fill in all required fields");
      return;
    }

    if (validateEmail(email) != null || validatePassword(password) != null) {
      return; // Stop execution if validation fails
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'email-already-in-use') {
        Uihelper.CustomAlertBox(context, "Email is already registered");
      } else {
        Uihelper.CustomAlertBox(context, ex.message ?? "An error occurred");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('SignUp here'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),

        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.jpeg'),
                    radius: 80,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Create Your Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Uihelper.CustomTextField(
                    emailController,
                    "Email",
                    Icons.mail,
                    false,
                  ),
                  const SizedBox(height: 10),
                  PasswordFieldHelper.CustomPasswordField(
                    passwordController,
                    "Password",
                    _isPasswordHidden,
                    _togglePasswordVisibility,
                  ),
                  const SizedBox(height: 20),
                  Uihelper.Custombutton(() {
                    signUp(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  }, "SignUp"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
