
import 'package:equatable/equatable.dart';
import 'package:music_api/models/character_user.dart';

abstract class CharacterUserState extends Equatable {}

class CharacterUserLoadingState extends CharacterUserState {
  @override
  List<Object> get props => [];
}

class CharacterUserLoadedState extends CharacterUserState {
  CharacterUserLoadedState({required this.character});

  final CharacterUser character;

  @override
  List<Object> get props => [character];
}

class CharacterUserErrorState extends CharacterUserState {
  CharacterUserErrorState({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}