import 'package:flutter/material.dart';
import 'package:music_api/presentation/screens/Books/all_books/all_books_screen.dart';
import 'package:music_api/presentation/screens/Books/all_chapters/chapters_screen.dart';
import 'package:music_api/presentation/screens/Books/book_option/book_option.dart';
import 'package:music_api/presentation/screens/Characters/all_characters/all_characters.dart';
import 'package:music_api/presentation/screens/Books/id_book/id_book_screen.dart';
import 'package:music_api/presentation/screens/Characters/character_option/character_option.dart';
import 'package:music_api/presentation/screens/Characters/id_character/id_character.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: '/',
        routes: {
          '/BookOptions': (context) => const BookOptionScreen(),
          '/CharacterOptions': (context) => const CharacterOptionScreen(),
          '/Chapters': (context) => const ChaptersScreen(
                bookId: '',
              ),
          '/AllBooks': (context) => const AllBooksScreen(),
          '/IDBook': (context) => const IDBookScreen(),
          '/AllCharacters': (context) => const AllCharactersScreenState(),
          '/IDCharacter': (context) => const IDCharacter()
        });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenido a la Aplicación',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
                height: 20), // Espaciado entre el mensaje y los botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla BookOptionScreen
                Navigator.pushNamed(context, '/BookOptions');
              },
              child: const Text('Opciones de Libros'),
            ),
            const SizedBox(height: 20), // Espaciado entre los botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla CharacterOptionScreen
                Navigator.pushNamed(context, '/CharacterOptions');
              },
              child: const Text('Opciones de Personajes'),
            ),
          ],
        ),
      ),
    );
  }
}
