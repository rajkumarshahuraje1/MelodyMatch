import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SearchScreen extends StatefulWidget {
  final String songName; // Receives song name from Home Page search box

  const SearchScreen({super.key, required this.songName});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Send song name to server immediately
    _fetchSongUrl(widget.songName);
  }

  // Function to send song name to Python backend and get YouTube song URL
  Future<void> _fetchSongUrl(String songName) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final uri = Uri.parse('http://192.168.43.117:5001/find_song'); // Update with Python server URL
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'song_name': songName}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String songUrl = data['url'];

        // Extract video ID and navigate to player
        String? videoId = _extractVideoId(songUrl);
        if (videoId != null) {
          if (mounted) {
            setState(() => _isLoading = false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => YouTubePlayerScreen(videoId: videoId)),
            );
          }
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid YouTube URL.';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to find the song: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  // Extract video ID from YouTube URL
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
            ? _buildLoadingIndicator()
            : _errorMessage.isNotEmpty
            ? _buildErrorUI()
            : const Text(
          'Wait a moment...',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Colors.deepPurple),
        const SizedBox(height: 20),
        const Text('Fetching song...', style: TextStyle(fontSize: 18, color: Colors.deepPurple)),
      ],
    );
  }

  Widget _buildErrorUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 50),
        const SizedBox(height: 20),
        Text(_errorMessage, style: const TextStyle(fontSize: 18, color: Colors.red), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _fetchSongUrl(widget.songName),
          child: const Text('Retry'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false, enableCaption: false, isLive: false),
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
      player: YoutubePlayer(controller: _controller, showVideoProgressIndicator: true, progressIndicatorColor: Colors.deepPurple),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(title: const Text('Now Playing'), backgroundColor: Colors.deepPurple),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Enjoy the song!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1.5, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.9, child: player),
                ],
              ),

            ),
          ),
        );
      },
    );
  }
}
