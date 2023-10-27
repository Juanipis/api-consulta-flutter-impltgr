import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/books/book_blocs.dart';
import 'package:music_api/blocs/books/book_events.dart';
import 'package:music_api/blocs/books/book_states.dart';
import 'package:music_api/repositories/book.dart';

class IDBookScreen extends StatefulWidget {
  const IDBookScreen({super.key});

  @override
  State<IDBookScreen> createState() => _IDBookScreenState();
}

class _IDBookScreenState extends State<IDBookScreen> {
  String id = '5420a23c-e26c-4f64-9b9a-c2efd5477afa'; // Ejemplo de ID

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookBloc(BookRepository())..add(LoadBookByIdEvent(id)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ID Book'),
        ),
        body: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BookLoadedByIdState) {
              // Solicitar los capítulos del libro después de obtener los detalles del libro
              context.read<BookBloc>().add(LoadChaptersByBookIdEvent(id));

              return Column(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.book.attributes.title),
                        Text(state.book.attributes.author),
                        // Mostrar la portada del libro
                        Image.network(state.book.attributes.cover),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<BookBloc, BookState>(
                      builder: (context, chapterState) {
                        if (chapterState is ChaptersLoadedState) {
                          return ListView.builder(
                            itemCount: chapterState.chapters.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(chapterState.chapters[index].id),
                                subtitle:
                                    Text(chapterState.chapters[index].type),
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              );
            }
            if (state is BookErrorState) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text(''));
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: IDBookScreen(),
  ));
}
