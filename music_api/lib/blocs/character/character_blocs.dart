import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/character/character_events.dart';
import 'package:music_api/blocs/character/character_states.dart';
import 'package:music_api/repositories/character.dart';
import 'package:http/http.dart' as http;

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository characterRepository;

  CharacterBloc(this.characterRepository) : super(CharacterLoadingState()) {
    on<LoadCharacterEvent>((event, emit) async {
      emit(CharacterLoadingState());
      try {
        final characters = await characterRepository.getAllCharacters();
        emit(CharacterLoadedState(characters: characters));
      } catch (e) {
        emit(CharacterErrorState(message: e.toString()));
      }
    });

    on<LoadCharacterByIdEvent>((event, emit) async {
      emit(CharacterLoadingState());
      try {
        final character = await characterRepository.getCharacterById(event.id);
        emit(CharacterLoadedByIdState(character: character));
      } catch (e) {
        emit(CharacterErrorState(message: e.toString()));
      }
    });

    on<InsertCharacterEvent>((event, emit) async {
      emit(CharacterLoadingState()); // Mostrar estado de carga
      try {
        final response = await http.get(Uri.parse(event.imageUrl));
        final imageBytes = response.bodyBytes;
        final result = await characterRepository.insertCharacter(
            event.uuid, imageBytes, event.imageName);
        if (result) {
          emit(
              CharacterInsertedState()); // Emitir un nuevo estado cuando se inserte el personaje
        } else {
          emit(
              CharacterErrorState(message: "No se pudo insertar el personaje"));
        }
      } catch (e) {
        emit(CharacterErrorState(message: e.toString()));
      }
    });
  }
}
