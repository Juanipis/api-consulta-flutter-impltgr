
import 'package:equatable/equatable.dart';

abstract class CharacterUserEvent extends Equatable {
  const CharacterUserEvent();
}

class LoadCharacterUser extends CharacterUserEvent {
  final String uuid;
  const LoadCharacterUser(this.uuid);

  @override
  List<Object> get props => [uuid];
}