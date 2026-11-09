class Character {
  final String id;
  final String type;
  final Attributes attributes;
  final Links links;

  Character({required this.id, required this.type, required this.attributes, required this.links});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      type: json['type'],
      attributes: Attributes.fromJson(json['attributes']),
      links: Links.fromJson(json['links']),
    );
  }
}

class Attributes {
  final String slug;
  final List<String> aliasNames;
  final dynamic animagus;
  final dynamic bloodStatus;
  final dynamic boggart;
  final dynamic born;
  final dynamic died;
  final dynamic eyeColor;
  final List<String> familyMembers;
  final dynamic gender;
  final dynamic hairColor;
  final dynamic height;
  final dynamic house;
  final dynamic image;
  final List<String> jobs;
  final dynamic maritalStatus;
  final String name;
  final dynamic nationality;
  final dynamic patronus;
  final List<String> romances;
  final dynamic skinColor;
  final dynamic species;
  final List<String> titles;
  final List<String> wands;
  final dynamic weight;
  final String wiki;

  Attributes({
    required this.slug,
    required this.aliasNames,
    this.animagus,
    this.bloodStatus,
    this.boggart,
    this.born,
    this.died,
    this.eyeColor,
    required this.familyMembers,
    this.gender,
    this.hairColor,
    this.height,
    this.house,
    this.image,
    required this.jobs,
    this.maritalStatus,
    required this.name,
    this.nationality,
    this.patronus,
    required this.romances,
    this.skinColor,
    this.species,
    required this.titles,
    required this.wands,
    this.weight,
    required this.wiki,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      slug: json['slug'],
      aliasNames: List<String>.from(json['alias_names']),
      animagus: json['animagus'],
      bloodStatus: json['blood_status'],
      boggart: json['boggart'],
      born: json['born'],
      died: json['died'],
      eyeColor: json['eye_color'],
      familyMembers: List<String>.from(json['family_members']),
      gender: json['gender'],
      hairColor: json['hair_color'],
      height: json['height'],
      house: json['house'],
      image: json['image'],
      jobs: List<String>.from(json['jobs']),
      maritalStatus: json['marital_status'],
      name: json['name'],
      nationality: json['nationality'],
      patronus: json['patronus'],
      romances: List<String>.from(json['romances']),
      skinColor: json['skin_color'],
      species: json['species'],
      titles: List<String>.from(json['titles']),
      wands: List<String>.from(json['wands']),
      weight: json['weight'],
      wiki: json['wiki'],
    );
  }
}

class Links {
  final String self;

  Links({required this.self});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      self: json['self'],
    );
  }
}
