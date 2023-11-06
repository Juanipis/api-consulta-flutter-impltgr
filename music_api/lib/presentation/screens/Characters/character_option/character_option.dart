import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/character/character_blocs.dart';
import 'package:music_api/repositories/character.dart';
import 'package:music_api/presentation/screens/Characters/all_characters/all_characters.dart';
import 'package:music_api/presentation/screens/Characters/id_character/id_character.dart';

class CharacterOptionScreen extends StatelessWidget {
  const CharacterOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones de Personajes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Crear una instancia de CharacterBloc
                CharacterBloc characterBloc =
                    CharacterBloc(CharacterRepository());

                // Navegar a la pantalla que muestra todos los personajes
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: characterBloc,
                      child: const AllCharactersScreenState(),
                    ),
                  ),
                );
              },
              child: const Text('Mostrar Todos los Personajes'),
            ),
            const SizedBox(height: 20), // Espaciado entre los botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla que muestra los personajes por ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => CharacterBloc(CharacterRepository()),
                      child: const IDCharacter(),
                    ),
                  ),
                );
              },
              child: const Text('Buscar por ID'),
            ),
          ],
        ),
      ),
    );
  }
}
