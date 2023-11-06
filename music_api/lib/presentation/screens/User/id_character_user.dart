import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/character_user/character_user_blocs.dart';
import 'package:music_api/blocs/character_user/character_user_events.dart';
import 'package:music_api/blocs/character_user/character_user_states.dart';

class IDCharacterUser extends StatefulWidget {
  const IDCharacterUser({super.key});

  @override
  State<IDCharacterUser> createState() => _IDCharacterUserState();
}

class _IDCharacterUserState extends State<IDCharacterUser> {
  String uuid = '';
  final TextEditingController _controller = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ID Character User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajuste aquí
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el UUID del usuario',
                ),
                onChanged: (value) {
                  uuid = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Disparar el evento para cargar el usuario por UUID
                  BlocProvider.of<CharacterUserBloc>(context)
                      .add(LoadCharacterUser(uuid));
                },
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 20),
              BlocBuilder<CharacterUserBloc, CharacterUserState>(
                builder: (context, state) {
                  if (state is CharacterUserLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CharacterUserLoadedState) {
                    final characterUser = state.character;
                    final images = characterUser.data.entries
                        .map((entry) {
                          final bytes = base64Decode(entry.value);
                          return Image.memory(bytes, fit: BoxFit.cover);
                        })
                        .toList();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('UUID: ${characterUser.uuid}'),
                        Flexible(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), // Deshabilitar el scroll en GridView
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 150, // Tamaño máximo para las imágenes
                                  ),
                                  child: images[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is CharacterUserErrorState) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Introduzca un UUID para buscar'));
                },
              ),
            ],
          ),
        ),
      ),
    );
    
  }
}
