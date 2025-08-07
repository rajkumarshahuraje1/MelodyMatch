import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'song.dart';
import 'Songlist.dart';
import 'HomePage.dart';

class ScanFaceScreen extends StatefulWidget {
  final File image; // Image passed as parameter from homepage

  const ScanFaceScreen({super.key, required this.image});

  @override
  State<ScanFaceScreen> createState() => _ScanFaceScreenState();
}

class _ScanFaceScreenState extends State<ScanFaceScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Automatically send the image to the server when screen loads
    _sendImageToPython(widget.image);
  }

  // Function to send image as base64 to the Python server
  Future<void> _sendImageToPython(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(bytes);

      // Prepare the POST request
      final uri = Uri.parse('http://192.168.43.117:5001/scan_face'); // Replace with your Python server URL
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        // Parse response
        final data = jsonDecode(response.body);
        final mood = data['mood'];
        final List<dynamic> songData = data['songs'];

        // Convert song data to a list of Song objects
        List<Song> songs = songData.map((json) => Song.fromJson(json)).toList();

        // Navigate to the SongListScreen
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongListScreen(mood: mood, songs: songs),
            ),
          );
        }
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to process image: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );

      // Navigate to HomePage after showing the snackbar
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    }
    finally {
      // Check if the widget is still mounted before calling setState
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Face', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading indicator if _isLoading is true
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 105,
              backgroundColor: Colors.deepPurple,
              backgroundImage: FileImage(widget.image), // Display the passed image
            ),
            const SizedBox(height: 20),
            const Text(
              'Scanning in progress...',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
