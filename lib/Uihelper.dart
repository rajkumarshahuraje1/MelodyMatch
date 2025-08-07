import 'package:flutter/material.dart';

class Uihelper{
  static CustomTextField(TextEditingController controller,String text,IconData iconData,bool toHide)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
          hintText: text,
          suffixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25)
          )
        ),
      ),
    );
  }
  static Custombutton(VoidCallback voidCallback,String text){
    return SizedBox(height: 50,width: 300,child:
      ElevatedButton(onPressed:(){
        voidCallback();
      },
      style: ElevatedButton.styleFrom(
       backgroundColor: Colors.blue,
      ), child: Text(text,style: const TextStyle(color: Colors.white,fontSize: 20),)),);

  }
  static CustomAlertBox(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners for AlertDialog
          ),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800, // Blue color for title
            ),
          ),
          content: const Text(
            'Please take the necessary action.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87, // Dark gray color for content text
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                  color: Colors.blue, // Blue text for the button
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}