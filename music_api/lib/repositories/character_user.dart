import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:music_api/models/character_user.dart';

final apiHost = dotenv.env['API_HOST'];

class CharacterUserRepository {
  Future<CharacterUser> getUserCharacters(String uuid) async {
    Uri uri = Uri.parse('$apiHost/character/get_character_images_bytes/$uuid');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CharacterUser.fromJson(data);
    } else {
      throw Exception('Failed to load user characters');
    }
  }

  Future<bool> insertNewCharacterImage(
      String characterUuid, Uint8List fileBytes, String fileName) async {
    var uri = Uri.parse('$apiHost/character/insert_new_character_image');
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
    print(responseString);

    if (response.statusCode == 200) {
      var responseJson = json.decode(responseString);
      return responseJson['inserted'];
    } else {
      throw Exception(
          'Failed to upload image: Server responded with status code ${response.statusCode}');
    }
  }

  Future<List<String>> getUserCharactersUUIDList() async {
    Uri uri = Uri.parse('$apiHost/character/get_all_characters_uuids');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final uuidList = List<String>.from(data['uuid_list']);
      return uuidList.isNotEmpty ? uuidList : [];
    } else {
      throw Exception('Failed to load user characters');
    }
  }

  Future<bool> deleteAllCharacters() {
    Uri uri = Uri.parse('$apiHost/character/clean_database');
    return http.delete(uri).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete database');
      }
    });
  }
}
