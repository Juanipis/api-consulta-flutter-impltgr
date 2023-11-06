class CharacterUser {
  final String uuid;
  final Map<String, String> data;

  CharacterUser({required this.uuid, required this.data});

  factory CharacterUser.fromJson(Map<String, dynamic> json) {
    return CharacterUser(
      uuid: json['character_uuid'],
      data: Map<String, String>.from(json['data']),
    );
  }
}