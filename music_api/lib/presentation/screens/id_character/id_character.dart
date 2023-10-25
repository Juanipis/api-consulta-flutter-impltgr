
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/character/character_blocs.dart';
import 'package:music_api/blocs/character/character_events.dart';
import 'package:music_api/blocs/character/character_states.dart';
import 'package:music_api/repositories/character.dart';

class IDCharacter extends StatefulWidget {
  const IDCharacter({super.key});

  @override
  State<IDCharacter> createState() => _IDCharacterState();
}

class _IDCharacterState extends State<IDCharacter> {
  String id = '0a65f181-d6fa-4d7d-be97-00ad0636a063';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=> CharacterBloc(CharacterRepository())..add(LoadCharacterByIdEvent(id)),
    child: Scaffold(
      appBar: AppBar(
        title: const Text('ID Character'),
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state){
          if (state is CharacterLoadingState){
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CharacterLoadedByIdState){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.character.id),
                  Text(state.character.type),
                  //Show the image
                  Image.network(state.character.attributes.image),
                ],
              ),
            );
          }
          if (state is CharacterErrorState){
            return Center(child: Text(state.message));
          }
          return const Center(child: Text(''));
        },
      ),
    ),
    );
  }
}

void main(){
  runApp(const MaterialApp(
    home: IDCharacter(),
  ));
}