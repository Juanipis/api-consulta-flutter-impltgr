
import 'package:equatable/equatable.dart';
import 'package:music_api/models/character.dart';

abstract class CharacterState extends Equatable {}

class CharacterLoadingState extends CharacterState {
  @override
  List<Object> get props => [];
}

class CharacterLoadedState extends CharacterState {
  CharacterLoadedState({required this.characters});
  final List<Character> characters;

  @override
  List<Object> get props => [characters];
}

class CharacterErrorState extends CharacterState {
  CharacterErrorState({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class CharacterLoadedByIdState extends CharacterState {
  final Character character;

  CharacterLoadedByIdState({required this.character});

  @override
  List<Object> get props => [character];
}
