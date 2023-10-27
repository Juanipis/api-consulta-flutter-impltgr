import 'package:equatable/equatable.dart';
import 'package:music_api/models/book.dart';

abstract class BookState extends Equatable {}

class BookLoadingState extends BookState {
  @override
  List<Object> get props => [];
}

class BookLoadedState extends BookState {
  final List<Book> books;

  BookLoadedState({required this.books});

  @override
  List<Object> get props => [books];
}

class BookErrorState extends BookState {
  final String message;

  BookErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class BookLoadedByIdState extends BookState {
  final Book book;

  BookLoadedByIdState({required this.book});

  @override
  List<Object> get props => [book];
}

class ChaptersLoadedState extends BookState {
  final List<ChapterData> chapters;

  ChaptersLoadedState({required this.chapters});

  @override
  List<Object> get props => [chapters];
}

class ChapterLoadedState extends BookState {
  final ChapterData chapter;

  ChapterLoadedState({required this.chapter});

  @override
  List<Object> get props => [chapter];
}
