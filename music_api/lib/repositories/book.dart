import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_api/models/book.dart';

class BookRepository {
  // Obtener todos los libros
  Future<List<Book>> getAllBooks() async {
    Uri uri = Uri.parse('https://api.potterdb.com/v1/books');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final books = data['data'] as List;
      return books.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Error fetching books');
    }
  }

  // Obtener libro por id
  Future<Book> getBookById(String id) async {
    Uri uri = Uri.parse('https://api.potterdb.com/v1/books/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Book.fromJson(data['data']);
    } else {
      throw Exception('Error fetching book');
    }
  }

  // Obtener capítulos de un libro específico
  Future<List<Chapter>> getChaptersByBookId(String bookId) async {
    Uri uri = Uri.parse('https://api.potterdb.com/v1/books/$bookId/chapters');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Response: $data'); // Imprimir la respuesta para verificarla
      final chapters = data['data'] as List;
      return chapters.map((chapter) => Chapter.fromJson(chapter)).toList();
    } else {
      throw Exception('Error fetching chapters');
    }
  }

  // Obtener un capítulo específico de un libro específico
  Future<Chapter> getChapterByBookIdAndChapterId(
      // Cambiado de ChapterData a Chapter
      String bookId,
      String chapterId) async {
    Uri uri = Uri.parse(
        'https://api.potterdb.com/v1/books/$bookId/chapters/$chapterId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Chapter.fromJson(
          data['data']); // Cambiado de ChapterData a Chapter
    } else {
      throw Exception('Error fetching chapter');
    }
  }
}
