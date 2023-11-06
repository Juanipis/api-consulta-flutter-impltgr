import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/character/character_blocs.dart';
import 'package:music_api/blocs/character/character_events.dart';
import 'package:music_api/blocs/character/character_states.dart';
import 'package:music_api/models/character.dart';

class AllCharactersScreenState extends StatefulWidget {
  const AllCharactersScreenState({super.key});

  @override
  State<AllCharactersScreenState> createState() =>
      __AllCharactersScreenStateState();
}

class __AllCharactersScreenStateState extends State<AllCharactersScreenState> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    // Solicitar la carga de la primera página al iniciar
    context
        .read<CharacterBloc>()
        .add(LoadCharacterEvent(pageNumber: currentPage));

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: characterBuilder()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: currentPage > 1
                    ? () {
                        setState(() {
                          currentPage--;
                        });
                        context
                            .read<CharacterBloc>()
                            .add(LoadCharacterEvent(pageNumber: currentPage));
                      }
                    : null,
                child: const Text('Anterior'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentPage++;
                  });
                  print("Cargando página $currentPage"); // Agregar esta línea
                  context
                      .read<CharacterBloc>()
                      .add(LoadCharacterEvent(pageNumber: currentPage));
                },
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BlocBuilder<CharacterBloc, CharacterState> characterBuilder() {
    return BlocBuilder(builder: (context, state) {
      if (state is CharacterLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is CharacterLoadedState) {
        List<Character> characterList = state.characters;
        return ListView.builder(
          itemCount: characterList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading:
                    Image.network(characterList[index].attributes.image ?? ''),
                title: Text(characterList[index].attributes.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Casa: ${characterList[index].attributes.house ?? 'Desconocido'}'),
                    Text(
                        'Nacimiento: ${characterList[index].attributes.born ?? 'Desconocido'}'),
                    Text(
                        'Género: ${characterList[index].attributes.gender ?? 'Desconocido'}'),
                    Text(
                        'Nacionalidad: ${characterList[index].attributes.nationality ?? 'Desconocido'}'),
                  ],
                ),
                onTap: () {
                  // Opcional: Puedes añadir una acción al tocar el ListTile
                },
              ),
            );
          },
        );
      }
      if (state is CharacterErrorState) {
        return Center(child: Text(state.message));
      }
      return const Center(child: Text(''));
    });
  }
}
