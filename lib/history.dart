import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Make purchaseHistory static so it can be accessed globally
  static List<Map<String, dynamic>> purchaseHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchPurchaseHistory();
  }

  Future<void> _fetchPurchaseHistory() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/savePayment.php'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          purchaseHistory = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load purchase history');
      }
    } catch (e) {
      print('Error fetching purchase history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History'),
      ),
      body: purchaseHistory.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: purchaseHistory.length,
              itemBuilder: (context, index) {
                final payment = purchaseHistory[index];
                return Card(
                  child: ListTile(
                    title: Text(payment['film']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Seats: ${payment['seats']}'),
                        Text('Day: ${payment['day']}'),
                        Text('Time: ${payment['time']}'),
                        Text('Studio: ${payment['studio']}'),
                      ],
                    ),
                    trailing: Text('Rp ${payment['total']}'),
                  ),
                );
              },
            ),
    );
  }
}
