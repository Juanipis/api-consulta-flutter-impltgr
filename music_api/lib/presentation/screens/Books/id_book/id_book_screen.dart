import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/books/book_blocs.dart';
import 'package:music_api/blocs/books/book_events.dart';
import 'package:music_api/blocs/books/book_states.dart';
import 'package:music_api/repositories/book.dart';

import '../id_chapters/id_chapters.dart';

class IDBookScreen extends StatefulWidget {
  const IDBookScreen({super.key});

  @override
  State<IDBookScreen> createState() => _IDBookScreenState();
}

class _IDBookScreenState extends State<IDBookScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookBloc(BookRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ID Book'),
        ),
        body: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Ingrese el ID del libro',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<BookBloc>()
                          .add(LoadBookByIdEvent(_controller.text));
                    },
                    child: const Text('Buscar Libro'),
                  ),
                  const SizedBox(height: 20),
                  if (state is BookLoadingState)
                    const Center(child: CircularProgressIndicator()),
                  if (state is BookLoadedByIdState) ...[
                    Text('Título: ${state.book.attributes?.title}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('Autor: ${state.book.attributes?.author}'),
                    const SizedBox(height: 5),
                    Text('Resumen: ${state.book.attributes?.summary}'),
                    const SizedBox(height: 5),
                    Text(
                        'Fecha de Publicación: ${state.book.attributes?.releaseDate}'),
                    const SizedBox(height: 5),
                    Text('Número de Páginas: ${state.book.attributes?.pages}'),
                    const SizedBox(height: 5),
                    Image.network(state.book.attributes!.cover),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChaptersByID(bookId: state.book.id),
                          ),
                        );
                      },
                      child: const Text('Mostrar Capítulos'),
                    ),
                  ],
                  if (state is BookErrorState)
                    Center(child: Text(state.message)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
