import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_api/models/character_user.dart';

class CharacterUserRepository{
  Future<CharacterUser> getUserCharacters(String uuid) async {
    Uri uri = Uri.parse('http://127.0.0.1:8000/character/get_character_images_bytes/$uuid');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CharacterUser.fromJson(data);
    } else {
      throw Exception('Failed to load user characters');
    }
  }
}