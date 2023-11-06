import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/character_user/character_user_events.dart';
import 'package:music_api/blocs/character_user/character_user_states.dart';
import 'package:music_api/repositories/character_user.dart';

class CharacterUserBloc extends Bloc<CharacterUserEvent, CharacterUserState>{
  final CharacterUserRepository characterUserRepository;

  CharacterUserBloc(this.characterUserRepository) : super(CharacterUserLoadingState()){
    on<LoadCharacterUser>((event, emit) async {
      emit(CharacterUserLoadingState());
      try{
        final character = await characterUserRepository.getUserCharacters(event.uuid);
        

        emit(CharacterUserLoadedState(character: character));
      } catch (e) {
        emit(CharacterUserErrorState(message: e.toString()));
      }
    });
  }
}