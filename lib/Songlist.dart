import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // For YouTube playback
import 'song.dart'; // Import the Song model

class SongListScreen extends StatelessWidget {
  final String mood; // The mood received from the Flask server
  final List<Song> songs; // List of songs (URLs) received from the Flask server

  const SongListScreen({super.key, required this.mood, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Songs for Mood: $mood',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: songs.isEmpty
            ? const Center(
          child: Text(
            'No songs found for this mood.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        )
            : ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index]; // Get the song data at index
            return _buildSongCard(context, song);
          },
        ),
      ),
    );
  }

  Widget _buildSongCard(BuildContext context, Song song) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      color: Colors.deepPurple.shade100,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          song.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
          ),
        ),
        subtitle: Text(
          "Mood: $mood",
          style: TextStyle(
            fontSize: 14,
            color: Colors.deepPurple[400],
          ),
        ),
        trailing: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.deepPurple,
            size: 30,
          ),
        ),
        onTap: () {
          _playYouTubeSong(context, song.url); // Pass context to method
        },
      ),
    );
  }

  // Function to play YouTube song
  void _playYouTubeSong(BuildContext context, String url) {
    final String videoId = YoutubePlayer.convertUrlToId(url)!; // Extract YouTube video ID from URL

    // Navigate to a new screen to play the video using YoutubePlayer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubePlayerScreen(videoId: videoId),
      ),
    );
  }
}

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubePlayerScreen({super.key, required this.videoId});

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
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
        enableCaption: true,
        isLive: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
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
          appBar: AppBar(
            title: const Text('Now Playing'),
            backgroundColor: Colors.deepPurple,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Enjoy the song!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.deepPurple,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: player,
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
