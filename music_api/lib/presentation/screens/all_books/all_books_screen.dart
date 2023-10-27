import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/books/book_blocs.dart';
import 'package:music_api/blocs/books/book_events.dart';
import 'package:music_api/blocs/books/book_states.dart';
import 'package:music_api/models/book.dart';
import 'package:music_api/presentation/all_chapters/chapters_screen.dart';
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
              return ListTile(
                title: Text(bookList[index].attributes.title),
                subtitle: Text(bookList[index].attributes.author),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChaptersScreen(bookId: bookList[index].id),
                    ),
                  );
                },
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
