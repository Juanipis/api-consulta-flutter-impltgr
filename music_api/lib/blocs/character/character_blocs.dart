
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/character/character_events.dart';
import 'package:music_api/blocs/character/character_states.dart';
import 'package:music_api/repositories/character.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState>{
  final CharacterRepository characterRepository;

  CharacterBloc(this.characterRepository) : super(CharacterLoadingState()){
    on<LoadCharacterEvent>((event, emit) async {
      emit(CharacterLoadingState());
      try{
        final characters = await characterRepository.getAllCharacters();
        emit(CharacterLoadedState(characters: characters));
      } catch (e) {
        emit(CharacterErrorState(message: e.toString()));
      }
    });
  }
}