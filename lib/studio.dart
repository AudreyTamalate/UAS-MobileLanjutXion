import 'package:flutter/material.dart';
import 'film.dart';

class StudioScreen extends StatelessWidget {
  final List<String> studios = ['Studio 1', 'Studio 2', 'Studio 3', 'Studio 4', 'Studio 5'];

  StudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Studio Selection')),
      body: ListView.builder(
        itemCount: studios.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(studios[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilmScreen()),
              );
            },
          );
        },
      ),
    );
  }
}
