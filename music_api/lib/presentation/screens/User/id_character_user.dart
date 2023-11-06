import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/character_user/character_user_blocs.dart';
import 'package:music_api/blocs/character_user/character_user_events.dart';
import 'package:music_api/blocs/character_user/character_user_states.dart';
import 'package:music_api/models/character_user.dart';
import 'package:music_api/repositories/character_user.dart';

class IDCharacterUser extends StatefulWidget {
  const IDCharacterUser({super.key});

  @override
  State<IDCharacterUser> createState() => _IDCharacterUserState();
}

class _IDCharacterUserState extends State<IDCharacterUser> {
  String uuid = '';
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Buscar imagenes de personaje guardado por UUID'),
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
                    final images = characterUser.data.entries.map((entry) {
                      final bytes = base64Decode(entry.value);
                      return Image.memory(bytes, fit: BoxFit.cover);
                    }).toList();

                    // Añadimos un nuevo Widget al final de la lista de Widgets que ya existen
                    List<Widget> columnChildren = [
                      Text('UUID: ${characterUser.uuid}'),
                      Flexible(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 3 : 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                constraints: const BoxConstraints(
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
                                title: Text(
                                    'Desea agregar más imagenes al personaje con el uuid ${characterUser.uuid}'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      bool inserted = await insertImage(
                                          context, characterUser);
                                      Navigator.pop(
                                          scaffoldKey.currentContext!);
                                      if (inserted) {
                                        BlocProvider.of<CharacterUserBloc>(
                                                scaffoldKey.currentContext!)
                                            .add(LoadCharacterUser(uuid));
                                      }
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Agregar imagen'),
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
                  return const Center(
                      child: Text('Introduzca un UUID para buscar'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> insertImage(
      BuildContext context, CharacterUser characterUser) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;

      CharacterUserRepository repository = CharacterUserRepository();

      try {
        bool uploadResult = await repository.insertNewCharacterImage(
            characterUser.uuid, fileBytes, fileName);
        if (uploadResult) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
                content: Text('Image uploaded successfully, please refresh')),
          );
        } else {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
                content: Text(
                    'Failed to upload image, no match face found in the image or the image is not a face image. Please try again with a different image or a different face in the image.')),
          );
        }
        return uploadResult;
      } catch (e) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
        return false;
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
      return false;
    }
  }
}
