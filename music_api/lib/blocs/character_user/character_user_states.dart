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

class CharacterUserUUIDListLoadedState extends CharacterUserState {
  CharacterUserUUIDListLoadedState({required this.uuidList});

  final List<String> uuidList;

  @override
  List<Object> get props => [uuidList];
}

class CharacterUserUUIDListErrorState extends CharacterUserState {
  CharacterUserUUIDListErrorState({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class CharacterUserUUIDListLoadingState extends CharacterUserState {
  @override
  List<Object> get props => [];
}

class CharacterDBDeleteState extends CharacterUserState {
  CharacterDBDeleteState({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
