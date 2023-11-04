import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_api/blocs/books/book_events.dart';
import 'package:music_api/blocs/books/book_states.dart';
import 'package:music_api/repositories/book.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository bookRepository;

  BookBloc(this.bookRepository) : super(BookLoadingState()) {
    on<LoadBookEvent>((event, emit) async {
      emit(BookLoadingState());
      try {
        final books = await bookRepository.getAllBooks();
        emit(BookLoadedState(books: books));
      } catch (e) {
        emit(BookErrorState(message: e.toString()));
      }
    });

    on<LoadBookByIdEvent>((event, emit) async {
      emit(BookLoadingState());
      try {
        final book = await bookRepository.getBookById(event.id);
        emit(BookLoadedByIdState(book: book));
      } catch (e) {
        emit(BookErrorState(message: e.toString()));
      }
    });

    on<LoadChaptersByBookIdEvent>((event, emit) async {
      emit(BookLoadingState());
      try {
        final chapters = await bookRepository.getChaptersByBookId(event.bookId);
        if (chapters == null || chapters.isEmpty) {
          emit(BookErrorState(message: 'No chapters found'));
        } else {
          emit(ChaptersLoadedState(chapters: chapters));
        }
      } catch (e) {
        emit(BookErrorState(message: e.toString()));
      }
    });

    on<LoadChapterByBookIdAndChapterIdEvent>((event, emit) async {
      emit(BookLoadingState());
      try {
        final chapter = await bookRepository.getChapterByBookIdAndChapterId(
            event.bookId, event.chapterId);
        emit(ChapterLoadedState(chapter: chapter));
      } catch (e) {
        emit(BookErrorState(message: e.toString()));
      }
    });
  }
}
