import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();
}

class LoadCharacterEvent extends CharacterEvent {
  final int pageNumber;
  const LoadCharacterEvent({this.pageNumber = 1});

  @override
  List<Object> get props => [pageNumber];
}

class LoadCharacterByIdEvent extends CharacterEvent {
  final String id;
  const LoadCharacterByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}
