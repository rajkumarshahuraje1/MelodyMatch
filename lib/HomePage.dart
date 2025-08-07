import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'serchsong.dart';
import 'scanfacescreen.dart';
import 'scansong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _scannedImage;

  // Function to automatically open the camera and capture an image after 3 seconds
  Future<void> _pickImageFromCamera() async {
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 2), () async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          _scannedImage = File(image.path);
        });

        // Navigate to the ScanFaceScreen with the captured image
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanFaceScreen(image: _scannedImage!),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood-based Music App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700, Colors.purple.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Box
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: SearchBox(),
                ),

                // Scan Face Section
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImageFromCamera,
                        child: CircleAvatar(
                          radius: 85,
                          backgroundColor: Colors.white,
                          backgroundImage: _scannedImage != null ? FileImage(_scannedImage!) : null,
                          child: _scannedImage == null
                              ? const Icon(Icons.camera_alt, color: Colors.deepPurple, size: 60)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImageFromCamera,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.deepPurple.shade100,
                          ),
                          child: const Text(
                            'Scan Face',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Trending Songs Header
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.deepPurple.shade700.withOpacity(0.8),
                    ),
                    child: const Text(
                      'Trending Songs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Trending Songs Sections
                ...songName.entries.map((entry) {
                  return TrendingSongsSection(
                    language: entry.key,
                    songs: entry.value,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dummy data for trending songs
  final Map<String, List<String>> songName = {


      'Hindi': ['Mitwa', 'Tujhe Dekha To', 'Pyar Diwana Hota Hai', 'Channa Mereya', 'Tum Hi Ho'],
      'Marathi': ['Ka Kalena', 'Tu Hi Re Majha Mitwa', 'Majhe Maher Pandhari', 'Mala Jau Dya Na Ghari', 'madanmanjiri'],
      'Tamil': ['Vaathi Coming', 'Vachindamma', 'Why This Kolaveri Di', 'Aaluma Doluma', 'Mukkala Mukabula'],
      'Punjabi': ['Titliaan', 'Brown Munde', 'Lahore', 'Excuses', 'Pasoori'],
      'Bengali': ['Tomake Chai', 'Mon Majhi Re', 'Bojhena Shey Bojhena', 'Tumi Jake Bhalobasho', 'Ei Poth Jodi Na Shesh Hoy'],
      'Telugu': ['Butta Bomma', 'Vachindamma', 'Ramuloo Ramulaa', 'Madhurame', 'Samajavaragamana'],
      'Kannada': ['Shuruvagide', 'Jeeva Hoovagide', 'Madhurame', 'Siri Siri Muvva', 'Naanu Neenu'],
      'Gujarati': ['Tari Aankh No Afini', 'Moj Majama', 'Sanedo', 'Kem Chho', 'Tari Vaari'],
      'Malayalam': ['Entammede Jimikki Kammal', 'Kudukku', 'Thaarame Thaarame', 'Manikya Malaraya Poovi', 'Pudikkanu Puthiya Puthu'],
      'Marwari': ['Padharo Mhare Desh', 'Moomal Maru', 'Kesariya Balam', 'Ghoomar', 'Mhari Teej'],
      'Bhojpuri': ['Lollipop Lagelu', 'Raate Diya Butake', 'Chhalakata Hamro Jawaniya', 'Piyawa Se Pahile', 'Nathuniya Ke Niche']


  };
}

// Search Box Widget
class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();

  void _searchSong() {
    String songName = _searchController.text.trim();

    if (songName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(songName: songName),
        ),
      );
    } else {
      // Show a message if the search box is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a song name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Colors.deepPurple),
          hintText: 'Search for songs',
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
          border: InputBorder.none,
        ),
        onSubmitted: (text) => _searchSong(), // Triggers search when "Enter" is pressed
      ),
    );
  }
}

// Trending Songs Section
class TrendingSongsSection extends StatelessWidget {
  final String language;
  final List<String> songs;

  const TrendingSongsSection({super.key, required this.language, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language Header
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepOrange.shade400.withOpacity(0.8),
              ),
              child: Text(
                language,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Horizontal ListView for songs
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                     //  ScaffoldMessenger.of(context).showSnackBar(
                     //    SnackBar(
                     //      content: Text('Playing ${songs[index]}...'),
                     //    ),
                     //  );
                     //Navigator.push(context,MaterialPageRoute(builder:(context)=>TrendingSongsSection(language: language, songs: songs)));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanSongScreen(songName: songs[index]),
                        ),
                      );

                    },
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 1.5),
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.music_note, color: Colors.black, size: 50),
                          const SizedBox(height: 10),
                          Text(
                            songs[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
