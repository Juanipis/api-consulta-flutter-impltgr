import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/books/book_blocs.dart';
import 'package:music_api/blocs/books/book_events.dart';
import 'package:music_api/blocs/books/book_states.dart';
import 'package:music_api/models/book.dart';
import 'package:music_api/presentation/screens/Books/id_chapters/id_chapters.dart';
import 'package:music_api/repositories/book.dart';

class AllBooksScreen extends StatefulWidget {
  const AllBooksScreen({super.key});

  @override
  State<AllBooksScreen> createState() => _AllBooksScreenState();
}

class _AllBooksScreenState extends State<AllBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookBloc(BookRepository())..add(LoadBookEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Libros')),
        body: bookBuilder(),
      ),
    );
  }

  BlocBuilder<BookBloc, BookState> bookBuilder() {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BookLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BookLoadedState) {
          List<Book> bookList = state.books;
          return ListView.builder(
            itemCount: bookList.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modificación del estilo del título
                      Text('Título: ${bookList[index].attributes?.title}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text('Autor: ${bookList[index].attributes?.author}'),
                      const SizedBox(height: 5),
                      Text('Resumen: ${bookList[index].attributes?.summary}'),
                      const SizedBox(height: 5),
                      Text(
                          'Fecha de Publicación: ${bookList[index].attributes?.releaseDate}'),
                      const SizedBox(height: 5),
                      Text(
                          'Número de Páginas: ${bookList[index].attributes?.pages}'),
                      const SizedBox(height: 5),
                      // Mostrar la portada del libro
                      Image.network(bookList[index].attributes!.cover),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChaptersByID(bookId: bookList[index].id),
                            ),
                          );
                        },
                        child: const Text('Ver Capítulos'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        if (state is BookErrorState) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text(''));
      },
    );
  }
}
