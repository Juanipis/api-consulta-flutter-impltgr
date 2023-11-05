import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/books/book_blocs.dart';
import 'package:music_api/blocs/books/book_events.dart';
import 'package:music_api/blocs/books/book_states.dart';
import 'package:music_api/repositories/book.dart';

class ChaptersByID extends StatelessWidget {
  final String bookId;

  const ChaptersByID({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookBloc(BookRepository())..add(LoadChaptersByBookIdEvent(bookId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Capítulos')),
        body: chaptersBuilder(),
      ),
    );
  }

  BlocBuilder<BookBloc, BookState> chaptersBuilder() {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BookLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ChaptersLoadedState) {
          return ListView.builder(
            itemCount: state.chapters.length,
            itemBuilder: (context, index) {
              final chapter = state.chapters[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Título: ${chapter.attributes?.title}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text('Orden: ${chapter.attributes?.order}'),
                      const SizedBox(height: 5),
                      Text('Resumen: ${chapter.attributes?.summary}'),
                      const SizedBox(height: 5),
                      Text('Slug: ${chapter.attributes?.slug}'),
                      const SizedBox(height: 10),
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
