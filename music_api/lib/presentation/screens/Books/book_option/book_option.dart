import 'package:flutter/material.dart';

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
                // Lógica para mostrar todos los libros
              },
              child: const Text('Mostrar Todos los Libros'),
            ),
            const SizedBox(height: 20), // Espaciado entre los botones
            ElevatedButton(
              onPressed: () {
                // Lógica para mostrar todos los capítulos
              },
              child: const Text('Mostrar Todos los Capítulos'),
            ),
            const SizedBox(height: 20), // Espaciado entre los botones
            ElevatedButton(
              onPressed: () {
                // Lógica para buscar por ID
              },
              child: const Text('Buscar por ID'),
            ),
          ],
        ),
      ),
    );
  }
}
