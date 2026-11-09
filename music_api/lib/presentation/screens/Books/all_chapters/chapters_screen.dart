import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/books/book_blocs.dart';
import 'package:music_api/blocs/books/book_events.dart';
import 'package:music_api/blocs/books/book_states.dart';
import 'package:music_api/models/book.dart';
import 'package:music_api/repositories/book.dart';

class ChaptersScreen extends StatefulWidget {
  final String bookId;

  const ChaptersScreen({required this.bookId, Key? key}) : super(key: key);

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookBloc(BookRepository())
        ..add(LoadChaptersByBookIdEvent(widget.bookId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chapters'),
        ),
        body: chaptersBuilder(),
      ),
    );
  }

  BlocBuilder<BookBloc, BookState> chaptersBuilder() {
    return BlocBuilder<BookBloc, BookState>(builder: (context, state) {
      if (state is BookLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is ChaptersLoadedState) {
        List<Chapter> chapterList =
            state.chapters; // Cambiado de ChapterData a Chapter
        return ListView.builder(
          itemCount: chapterList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(chapterList[index]
                  .attributes
                  !.title), // Mostrando el título del capítulo
              subtitle: Text(chapterList[index]
                  .attributes
                  !.summary), // Mostrando el resumen del capítulo
            );
          },
        );
      }
      if (state is BookErrorState) {
        return Center(child: Text(state.message));
      }
      return const Center(child: Text(''));
    });
  }
}
