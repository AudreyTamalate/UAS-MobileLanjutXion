import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _studioController = TextEditingController();
  final _dayController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedFilm;
  String? _selectedFilmTitle;
  List<Map<String, dynamic>> _films = [];

  @override
  void initState() {
    super.initState();
    _fetchFilms();
  }

  Future<void> _fetchFilms() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/saveFilm.php'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _films = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to load films');
      }
    } catch (e) {
      print('Error fetching films: $e');
    }
  }

  Future<void> _addSchedule() async {
    if (_selectedFilm == null || _selectedFilm!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a film')),
      );
      return;
    }

    final scheduleData = {
      'film_id': _selectedFilm!,
      'studio': _studioController.text,
      'day': _dayController.text,
      'time': _timeController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/saveSchedule.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(scheduleData),
      );

      if (response.statusCode == 200) {
        setState(() {
          _studioController.clear();
          _dayController.clear();
          _timeController.clear();
          _selectedFilm = null;
          _selectedFilmTitle = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule added successfully!')),
        );
      } else {
        throw Exception('Failed to add schedule');
      }
    } catch (e) {
      print('Error adding schedule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding schedule')),
      );
    }
  }

  void _showFilmSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: _films.length,
            itemBuilder: (context, index) {
              final film = _films[index];
              return ListTile(
                title: Text(
                  film['film_title'],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    _selectedFilm = film['id'].toString();
                    _selectedFilmTitle = film['film_title'];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchSchedules(String filmId) async {
    if (filmId.isEmpty) {
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/saveSchedule.php?film_id=$filmId'),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch schedules');
      }
    } catch (e) {
      print('Error fetching schedules: $e');
      return [];
    }
  }

  Future<void> _deleteSchedule(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/saveSchedule.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule deleted successfully!')),
        );
        setState(() {});
      } else {
        throw Exception('Failed to delete schedule');
      }
    } catch (e) {
      print('Error deleting schedule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting schedule')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Add Schedule',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _showFilmSelector,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedFilmTitle ?? 'Select Film',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(_studioController, 'Studio'),
            const SizedBox(height: 16),
            _buildTextField(_dayController, 'Day'),
            const SizedBox(height: 16),
            _buildTextField(_timeController, 'Time'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
              ),
              child: const Text('Add Schedule', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _selectedFilm == null
                  ? const Center(
                      child: Text(
                        'Select a film to view schedules',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchSchedules(_selectedFilm ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
                          );
                        }
                        final schedules = snapshot.data ?? [];
                        if (schedules.isEmpty) {
                          return const Center(
                            child: Text('No schedules available', style: TextStyle(color: Colors.white)),
                          );
                        }
                        return ListView.builder(
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = schedules[index];
                            return Card(
                              color: Colors.grey[900],
                              child: ListTile(
                                title: Text(
                                  '${schedule['studio']} - ${schedule['day']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Time: ${schedule['time']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  onPressed: () {
                                    _deleteSchedule(schedule['id'].toString());
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
