import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'seat.dart'; // Import for navigation to SeatScreen

class FilmScreen extends StatefulWidget {
  const FilmScreen({super.key});

  @override
  FilmScreenState createState() => FilmScreenState();
}

class FilmScreenState extends State<FilmScreen> {
  List<dynamic> films = [];
  List<Map<String, String>> schedules = [];
  bool isLoading = true;
  bool isFetchingSchedules = false;
  String searchQuery = "";

  String? selectedFilmId;
  String? selectedDay;
  String? selectedTime;
  String? selectedStudio;

  @override
  void initState() {
    super.initState();
    _fetchFilms();
  }

  Future<void> _fetchFilms() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/saveFilm.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          films = data.map((film) {
            return {
              'id': film['id']?.toString() ?? '0',
              'film_title': film['film_title']?.toString() ?? 'Unknown',
              'image': film['image']?.toString() ?? 'assets/default_image.jpg',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load films');
      }
    } catch (e) {
      print('Error fetching films: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchSchedules(String filmId) async {
    setState(() {
      isFetchingSchedules = true;
      selectedFilmId = filmId;
      schedules = [];
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/saveSchedule.php?film_id=$filmId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawSchedules = json.decode(response.body);

        setState(() {
          schedules = rawSchedules.map((schedule) {
            return {
              'day': schedule['day']?.toString() ?? 'N/A',
              'time': schedule['time']?.toString() ?? 'N/A',
              'studio': schedule['studio']?.toString() ?? 'N/A',
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      print('Error fetching schedules: $e');
    } finally {
      setState(() {
        isFetchingSchedules = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFilms = searchQuery.isEmpty
        ? films
        : films
            .where((film) =>
                film['film_title']!.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Selection'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search Films',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: filteredFilms.isEmpty
                      ? const Center(child: Text('No films available'))
                      : ListView.builder(
                          itemCount: filteredFilms.length,
                          itemBuilder: (context, index) {
                            final film = filteredFilms[index];
                            final filmId = film['id'] ?? '0';
                            final filmImage = film['image'] ?? 'assets/default_image.jpg';
                            final filmTitle = film['film_title'] ?? 'Unknown';

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    filmImage,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/default_image.jpg',
                                        height: 800,
                                        width: 600,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            filmTitle,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await _fetchSchedules(filmId);
                                            },
                                            child: isFetchingSchedules &&
                                                    selectedFilmId == filmId
                                                ? const SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                    child: CircularProgressIndicator(
                                                        strokeWidth: 2),
                                                  )
                                                : const Text('View Schedules'),
                                          ),
                                        ),
                                        if (!isFetchingSchedules &&
                                            schedules.isNotEmpty &&
                                            selectedFilmId == filmId)
                                          Column(
                                            children: schedules.map((schedule) {
                                              return ListTile(
                                                title: Center(
                                                  child: Text(
                                                    "${schedule['day']} - ${schedule['time']} - Studio: ${schedule['studio']}",
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    selectedDay = schedule['day'];
                                                    selectedTime = schedule['time'];
                                                    selectedStudio = schedule['studio'];
                                                  });
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        if (selectedFilmId == filmId &&
                                            selectedDay != null &&
                                            selectedTime != null &&
                                            selectedStudio != null)
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => SeatScreen(
                                                      filmTitle: filmTitle,
                                                      selectedDay: selectedDay!,
                                                      selectedTime: selectedTime!,
                                                      selectedStudio: selectedStudio!,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text('Buy Now'),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
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
