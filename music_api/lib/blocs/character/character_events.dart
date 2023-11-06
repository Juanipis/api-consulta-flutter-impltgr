import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();
}

class LoadCharacterEvent extends CharacterEvent {
  @override
  List<Object> get props => [];
}

class LoadCharacterByIdEvent extends CharacterEvent {
  final String id;
  const LoadCharacterByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class InsertCharacterEvent extends CharacterEvent {
  final String uuid;
  final String imageUrl;
  final String imageName;

  const InsertCharacterEvent({
    required this.uuid,
    required this.imageUrl,
    required this.imageName,
  });

  @override
  List<Object> get props => [uuid, imageUrl, imageName];
}
