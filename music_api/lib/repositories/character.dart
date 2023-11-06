import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_api/models/character.dart';

class CharacterRepository {
  Future<List<Character>> getAllCharacters(
      {int pageNumber = 1, int pageSize = 25}) async {
    Uri uri = Uri.parse(
        'https://api.potterdb.com/v1/characters?page[number]=$pageNumber&page[size]=$pageSize');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final characters = data['data'] as List;
      return characters
          .map((character) => Character.fromJson(character))
          .toList();
    } else {
      throw Exception('Error fetching characters');
    }
  }

  //Get character by id https://api.potterdb.com/v1/characters/{id}
  Future<Character> getCharacterById(String id) async {
    Uri uri = Uri.parse('https://api.potterdb.com/v1/characters/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Character.fromJson(data['data']);
    } else {
      throw Exception('Error fetching character');
    }
  }
}
