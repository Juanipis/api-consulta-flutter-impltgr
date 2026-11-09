import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart'; // Importa esto para usar Clipboard
import 'package:music_api/blocs/character_user/character_user_blocs.dart';
import 'package:music_api/blocs/character_user/character_user_events.dart';
import 'package:music_api/blocs/character_user/character_user_states.dart';

class IdAllCharacterState extends StatefulWidget {
  const IdAllCharacterState({super.key});

  @override
  State<IdAllCharacterState> createState() => _IdAllCharacterStateState();
}

class _IdAllCharacterStateState extends State<IdAllCharacterState> {
  // Función para copiar al portapapeles y mostrar SnackBar
  void copyToClipboard(BuildContext context, String uuid) {
    Clipboard.setData(ClipboardData(text: uuid)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personaje copiado'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharacterUserBloc>(context)
        .add(LoadCharacterUserUUIDList());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de todos los uuid de personajes guardados'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDeleteConfirmationDialog(context);
        },
        child: const Icon(Icons.delete),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<CharacterUserBloc, CharacterUserState>(
              builder: (context, state) {
                if (state is CharacterUserUUIDListLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CharacterUserUUIDListLoadedState) {
                  if (state.uuidList.isEmpty) {
                    return const Center(child: Text('No hay elementos'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.uuidList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.uuidList[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () =>
                              copyToClipboard(context, state.uuidList[index]),
                        ),
                      );
                    },
                  );
                }
                if (state is CharacterUserUUIDListErrorState) {
                  return Text(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar todos los personajes?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                // Aquí puedes llamar al evento que elimina la base de datos.
                BlocProvider.of<CharacterUserBloc>(context)
                    .add(LoadCharactersDBDelete());
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
                BlocProvider.of<CharacterUserBloc>(context)
                    .add(LoadCharacterUserUUIDList());
              },
            ),
          ],
        );
      },
    );
  }
}
