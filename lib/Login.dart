import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodymatch/Forgot.dart';
import 'package:moodymatch/HomePage.dart';
import 'package:moodymatch/SignUp.dart';
import 'package:moodymatch/Uihelper.dart';
import 'package:moodymatch/password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      return "Invalid email";
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 6) {
      return "Password too short";
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Uihelper.CustomAlertBox(context, "Please fill in all required fields");
      return;
    }

    String? emailError = validateEmail(email);
    String? passwordError = validatePassword(password);

    if (emailError != null) {
      Uihelper.CustomAlertBox(context, emailError);
      return;
    }

    if (passwordError != null) {
      Uihelper.CustomAlertBox(context, passwordError);
      return;


    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomePage()),
      );
    } on FirebaseAuthException catch (ex) {
      String errorMessage;
      if (ex.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (ex.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      } else if (ex.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
      } else {
        errorMessage = "Login failed. Please try again.";
      }
      Uihelper.CustomAlertBox(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Login here'),
        centerTitle: true,
      ),
      body: Center(
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
                  "Welcome !!",
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
                  login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                }, "Login"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "New User? ",
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                        );
                      },
                      child: Text(
                        'SignUp',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Forgot()),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
