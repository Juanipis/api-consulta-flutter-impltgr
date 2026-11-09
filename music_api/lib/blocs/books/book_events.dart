import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();
}

class LoadBookEvent extends BookEvent {
  @override
  List<Object> get props => [];
}

class LoadBookByIdEvent extends BookEvent {
  final String id;
  const LoadBookByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class LoadChaptersByBookIdEvent extends BookEvent {
  final String bookId;
  const LoadChaptersByBookIdEvent(this.bookId);

  @override
  List<Object> get props => [bookId];
}

class LoadChapterByBookIdAndChapterIdEvent extends BookEvent {
  final String bookId;
  final String chapterId;
  const LoadChapterByBookIdAndChapterIdEvent(this.bookId, this.chapterId);

  @override
  List<Object> get props => [bookId, chapterId];
}
