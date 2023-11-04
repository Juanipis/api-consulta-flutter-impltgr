import 'package:flutter/material.dart';
import 'package:music_api/presentation/screens/Books/all_books/all_books_screen.dart';
import 'package:music_api/presentation/screens/Books/all_chapters/chapters_screen.dart';
import 'package:music_api/presentation/screens/Books/id_book/id_book_screen.dart';

class BookOptionScreen extends StatelessWidget {
  const BookOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones de Libros'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla que muestra todos los libros
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllBooksScreen()),
                );
              },
              child: const Text('Mostrar Todos los Libros'),
            ),
            const SizedBox(height: 20), // Espaciado entre los botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla que permite buscar un libro por ID
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IDBookScreen()),
                );
              },
              child: const Text('Buscar por ID'),
            ),
          ],
        ),
      ),
    );
  }
}
