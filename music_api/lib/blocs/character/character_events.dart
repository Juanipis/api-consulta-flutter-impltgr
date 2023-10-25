
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