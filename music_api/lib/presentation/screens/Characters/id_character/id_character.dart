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
  String id = '';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ID Character'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Ingrese el ID del personaje',
              ),
              onChanged: (value) {
                id = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Disparar el evento para cargar el personaje por ID
                BlocProvider.of<CharacterBloc>(context)
                    .add(LoadCharacterByIdEvent(id));
              },
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<CharacterBloc, CharacterState>(
              builder: (context, state) {
                if (state is CharacterLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CharacterLoadedByIdState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ID: ${state.character.id}'),
                        Text('Tipo: ${state.character.type}'),
                        Text('Nombre: ${state.character.attributes.name}'),
                        Text(
                            'Casa: ${state.character.attributes.house ?? 'Desconocido'}'),
                        Text(
                            'Nacionalidad: ${state.character.attributes.nationality ?? 'Desconocido'}'),
                        Text(
                            'Género: ${state.character.attributes.gender ?? 'Desconocido'}'),
                        Text(
                            'Color de Ojos: ${state.character.attributes.eyeColor ?? 'Desconocido'}'),
                        Text(
                            'Color de Pelo: ${state.character.attributes.hairColor ?? 'Desconocido'}'),
                        // Verificar si la imagen es null antes de intentar mostrarla
                        if (state.character.attributes.image != null)
                          Image.network(state.character.attributes.image!),
                        // Puedes añadir un placeholder si la imagen es null
                        if (state.character.attributes.image == null)
                          const Text('No hay imagen disponible'),
                      ],
                    ),
                  );
                }
                if (state is CharacterErrorState) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text(''));
              },
            ),
          ],
        ),
      ),
    );
  }
}
