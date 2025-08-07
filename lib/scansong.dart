import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ScanSongScreen extends StatefulWidget {
  final String songName; // Single song name passed from HomePage

  const ScanSongScreen({super.key, required this.songName});

  @override
  State<ScanSongScreen> createState() => _ScanSongScreenState();
}

class _ScanSongScreenState extends State<ScanSongScreen> {
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Immediately send the song name to the server to fetch the URL and play it
    _sendSongToPython(widget.songName);
  }

  // Function to send song name to Python server and get the song URL
  Future<void> _sendSongToPython(String songName) async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Reset any previous error message
    });

    try {
      // Prepare the POST request
      final uri = Uri.parse('http://192.168.43.117:5001/find_song'); // Replace with your Python server URL
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'song_name': songName}),
      );

      if (response.statusCode == 200) {
        // Parse response from Python server
        final data = jsonDecode(response.body);
        final String songUrl = data['url']; // URL of the song returned by Python

        // Extract video ID from the URL
        String? videoId = _extractVideoId(songUrl);

        if (videoId != null) {
          // Navigate to the YouTube Player Screen to play the song
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => YouTubePlayerScreen(videoId: videoId),
              ),
            );
          }
        } else {
          // If no video ID is found, show an error message
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Invalid YouTube URL received.';
            });
          }
        }
      } else {
        // Show error if song URL could not be fetched
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Failed to find the song: ${response.body}';
          });
        }
      }
    } catch (e) {
      // Handle any errors that occur during the request
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: $e';
        });
      }
    }
  }

  // Function to manually extract the video ID from YouTube URL
  String? _extractVideoId(String url) {
    final RegExp regExp = RegExp(r"(?<=v=)[\w-]+");
    final match = regExp.firstMatch(url);
    return match?.group(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade200,
      appBar: AppBar(
        title: const Text('Loading...'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: _isLoading
            ? _buildLoadingIndicator() // Show loading indicator while fetching song URL
            : _errorMessage.isNotEmpty
            ? _buildErrorUI() // Show error message if song URL couldn't be found
            : const Text(
          'wait for a second',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
    );
  }

  // Widget to show loading indicator with a message
  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: Colors.deepPurple,
        ),
        const SizedBox(height: 20),
        Text(
          'Please wait, fetching the song...',
          style: TextStyle(fontSize: 18, color: Colors.deepPurple),
        ),
      ],
    );
  }

  // Widget to show error UI with a retry button
  Widget _buildErrorUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 50,
        ),
        const SizedBox(height: 20),
        Text(
          _errorMessage,
          style: TextStyle(fontSize: 18, color: Colors.red),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Retry fetching the song
            _sendSongToPython(widget.songName);
          },
          child: const Text('Retry'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green)
        ),
      ],
    );
  }
}
class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubePlayerScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  State<YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        isLive: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.deepPurple,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: const Text('Now Playing'),
            backgroundColor: Colors.deepPurple,
          ),
          body: Container(
            decoration: BoxDecoration(
            color: Colors.deepPurple.shade50
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Enjoy the song!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Display the YouTube player
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: player, // This is the YoutubePlayer wrapped in YoutubePlayerBuilder
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
