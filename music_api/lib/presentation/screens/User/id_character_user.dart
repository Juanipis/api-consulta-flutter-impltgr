import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:music_api/blocs/character_user/character_user_blocs.dart';
import 'package:music_api/blocs/character_user/character_user_events.dart';
import 'package:music_api/blocs/character_user/character_user_states.dart';
import 'package:music_api/repositories/character_user.dart';
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

                  // Añadimos un nuevo Widget al final de la lista de Widgets que ya existen
                  List<Widget> columnChildren = [
                    Text('UUID: ${characterUser.uuid}'),
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                              constraints:  const BoxConstraints(
                                maxHeight: 150,
                              ),
                              child: images[index],
                            ),
                          );
                        },
                      ),
                    ),
                    // Botón que se muestra solo si el estado es CharacterUserLoadedState
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Desea agregar más imagenes al personaje con el uuid ${characterUser.uuid}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () async {

                                    // Trigger file selection
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

                                    // If the user picked an image
                                    if (result != null) {
                                      Uint8List fileBytes = result.files.first.bytes!;
                                      String fileName = result.files.first.name;

                                      CharacterUserRepository repository = CharacterUserRepository();

                                      try {
                                        // Call the method to upload the image bytes
                                        var uploadResult = await repository.insertNewCharacterImage(characterUser.uuid, fileBytes, fileName);
                                        // Show a success message or update the UI accordingly
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Image uploaded successfully: $uploadResult')),
                                        );
                                      } catch (e) {
                                        // If the upload fails, show an error message
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to upload image: $e')),
                                        );
                                      }
                                    } else {
                                      // User canceled the picker
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('No image selected')),
                                      );
                                    }
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Mostrar UUID'),
                    ),
                  ];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: columnChildren,
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
