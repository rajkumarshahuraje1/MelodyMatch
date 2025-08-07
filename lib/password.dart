import 'package:flutter/material.dart';

class PasswordFieldHelper {
  // Static method to create a custom password field
  static Widget CustomPasswordField(
      TextEditingController controller,   // Password controller
      String text,                        // Hint text
      bool isPasswordHidden,              // Flag to hide/show password
      Function toggleVisibility,          // Function to toggle visibility
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: isPasswordHidden,  // Toggle password visibility
        decoration: InputDecoration(
          hintText: text,  // Hint text for the field
          suffixIcon: GestureDetector(
            onTap: () {
              toggleVisibility();  // Toggle password visibility when tapped
            },
            child: Icon(
              isPasswordHidden ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
