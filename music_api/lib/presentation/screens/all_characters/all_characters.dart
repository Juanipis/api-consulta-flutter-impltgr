import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/character/character_blocs.dart';
import 'package:music_api/blocs/character/character_events.dart';
import 'package:music_api/blocs/character/character_states.dart';
import 'package:music_api/models/character.dart';
import 'package:music_api/repositories/character.dart';

class AllCharactersScreenState extends StatefulWidget {
  const AllCharactersScreenState({super.key});

  @override
  State<AllCharactersScreenState> createState() => __AllCharactersScreenStateState();
}

class __AllCharactersScreenStateState extends State<AllCharactersScreenState> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => 
    CharacterBloc(CharacterRepository())..add(LoadCharacterEvent()),
    child: Scaffold(
      body: characterBuilder(),
    ),
    );
    
  }

  BlocBuilder<CharacterBloc, CharacterState> characterBuilder(){
    return BlocBuilder(builder: (context, state){
      if (state is CharacterLoadingState){
        return const Center(child: CircularProgressIndicator());
      }
      if (state is CharacterLoadedState){
        List<Character> characterList = state.characters;
        return ListView.builder(
          itemCount: characterList.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Text(characterList[index].id),
              subtitle: Text(characterList[index].type),
            );
          },
        );
      }
      if (state is CharacterErrorState){
        return Center(child: Text(state.message));
      }
      return const Center(child: Text(''));
    });
  }
}
