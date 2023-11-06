import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:music_api/models/character.dart';

final apiHost = dotenv.env['API_HOST'];

class CharacterRepository {
  Future<List<Character>> getAllCharacters() async {
    Uri uri = Uri.parse('https://api.potterdb.com/v1/characters');
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

  Future<bool> insertCharacter(
      String characterUuid, Uint8List fileBytes, String fileName) async {
    var uri = Uri.parse('$apiHost/character/insert_character');
    uri = uri.replace(queryParameters: {
      ...uri.queryParameters,
      'character_uuid': characterUuid, // Asegúrate de que esto no sea null.
    });

    var request = http.MultipartRequest("POST", uri);
    request.files.add(http.MultipartFile.fromBytes('character_image', fileBytes,
        filename: fileName));

    var response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseBytes);
    print(responseString); // Aquí verás el mensaje de error detallado.

    if (response.statusCode == 200) {
      var responseJson = json.decode(responseString);
      return responseJson['inserted'];
    } else {
      throw Exception(
          'Failed to upload image: Server responded with status code ${response.statusCode}');
    }
  }
}
