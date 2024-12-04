import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddFilmPage extends StatefulWidget {
  const AddFilmPage({super.key});

  @override
  _AddFilmPageState createState() => _AddFilmPageState();
}

class _AddFilmPageState extends State<AddFilmPage> {
  final _filmTitleController = TextEditingController();
  final _filmImageController = TextEditingController();
  List<Map<String, dynamic>> _films = []; // List to store films

  @override
  void initState() {
    super.initState();
    _fetchFilms(); // Fetch films when the page loads
  }

  // Fetch list of films from API
  Future<void> _fetchFilms() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/saveFilm.php'), // Adjust this endpoint
      );

      if (response.statusCode == 200) {
        final List<dynamic> films = json.decode(response.body);
        setState(() {
          _films = films.cast<Map<String, dynamic>>(); // Save films in the list
        });
      } else {
        throw Exception('Failed to fetch films');
      }
    } catch (e) {
      print('Error fetching films: $e');
    }
  }

  // Add a new film to the database
  Future<void> _addFilm() async {
    final title = _filmTitleController.text;
    final image = _filmImageController.text;

    // Ensure that title and image are not empty
    if (title.isEmpty || image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Image URL cannot be empty')),
      );
      return;
    }

    final filmData = {
      'film_title': title,
      'image': image,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/saveFilm.php'), // Adjust this endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filmData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Film added successfully.') {
          setState(() {
            _filmTitleController.clear();
            _filmImageController.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Film added successfully!')),
          );
          _fetchFilms(); // Refresh the list of films
        } else {
          throw Exception('Failed to add film');
        }
      } else {
        throw Exception('Failed to add film');
      }
    } catch (e) {
      print('Error adding film: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding film')),
      );
    }
  }

  // Delete a film from the database
  Future<void> _deleteFilm(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/saveFilm.php'), // Adjust this endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}), // Include ID in the request body
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Film deleted successfully.') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Film deleted successfully!')),
          );
          _fetchFilms(); // Refresh the list of films
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['message']}')),
          );
        }
      } else {
        throw Exception('Failed to delete film');
      }
    } catch (e) {
      print('Error deleting film: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting film')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Film',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _filmTitleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Film Title',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _filmImageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _addFilm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Film'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _films.isEmpty
                ? const Center(
                    child: Text(
                      'No films available',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: _films.length,
                    itemBuilder: (context, index) {
                      final film = _films[index];
                      final title = film['film_title'] ?? 'Unknown Title';
                      final image = film['image'] ?? '';

                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          title: Text(
                            title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: image.isNotEmpty
                              ? Image.network(
                                  image,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image,
                                          color: Colors.white),
                                )
                              : const Icon(Icons.broken_image,
                                  color: Colors.white),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color.fromARGB(255, 255, 159, 152)),
                            onPressed: () {
                              _deleteFilm(film['id'].toString());
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
