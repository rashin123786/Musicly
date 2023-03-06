import 'dart:convert';

import 'package:http/http.dart' as http;

import '../lyrics_model/lyrics_model.dart';

String isfound = '';

class LyricsSong {
  Future<String> getLyrics(
      {required String title, required String artist}) async {
    String apikey = '1e084976de8d0f8c2f74793b00c48da3';
    final response = await http.get(Uri.parse(
        "http://api.musixmatch.com/ws/1.1/matcher.lyrics.get?q_track=$title&q_artist=$artist&apikey=$apikey"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      final result = LyricsModel.fromJson(data);
      return result.message!.body!.lyrics!.lyricsBody!;
    } else {
      return '';
    }
  }
}
