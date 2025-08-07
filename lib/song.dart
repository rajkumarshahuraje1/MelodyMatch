// song.dart

class Song {
  final String title;
  final String url;

  Song({required this.title, required this.url});

  // Factory constructor to parse the JSON response from the server
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      url: json['url'],
    );
  }
}
