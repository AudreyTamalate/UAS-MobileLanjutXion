import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'history.dart'; // Ensure this is properly imported

class PaymentScreen extends StatelessWidget {
  final List<String> selectedSeats;
  final int totalPrice;
  final String selectedDay;
  final String selectedTime;
  final String selectedStudio;
  final String filmTitle;

  const PaymentScreen({
    super.key,
    required this.selectedSeats,
    required this.totalPrice,
    required this.selectedDay,
    required this.selectedTime,
    required this.selectedStudio,
    required this.filmTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container yang memanjang memenuhi layar
            Container(
              width: double.infinity, // Mengisi lebar layar
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black, // Warna kotak belakang hitam
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // Atur posisi bayangan
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Film: $filmTitle',
                    style: const TextStyle(fontSize: 18, color: Colors.white), // Teks putih
                  ),
                  Text(
                    'Studio: $selectedStudio',
                    style: const TextStyle(color: Colors.white), // Teks putih
                  ),
                  Text(
                    'Day: $selectedDay',
                    style: const TextStyle(color: Colors.white), // Teks putih
                  ),
                  Text(
                    'Time: $selectedTime',
                    style: const TextStyle(color: Colors.white), // Teks putih
                  ),
                  Text(
                    'Seats: ${selectedSeats.join(', ')}',
                    style: const TextStyle(color: Colors.white), // Teks putih
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total Price: Rp $totalPrice',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol bersebelahan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menyebar tombol
              children: [
                ElevatedButton(
                  onPressed: () => _processPayment(context, 'Bank Transfer'),
                  child: const Text('Pay via Bank Transfer'),
                ),
                ElevatedButton(
                  onPressed: () => _processPayment(context, 'E-Money'),
                  child: const Text('Pay via E-Money'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, String paymentMethod) async {
    // Prepare payment data
    Map<String, dynamic> paymentData = {
      'film': filmTitle,
      'studio': selectedStudio,
      'day': selectedDay,
      'time': selectedTime,
      'seats': selectedSeats,
      'total': totalPrice,
      'payment': paymentMethod,
    };

    // Send payment data to the server
    final response = await http.post(
      Uri.parse('http://10.0.2.2/ProjectUAS/uas/API/savePayment.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(paymentData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 200) {
        // Pass payment data back to the HistoryScreen
        Navigator.pop(context, paymentData);

        // Navigate directly to the History screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
      } else {
        _showMessage(context, 'Payment Failed', 'Data tidak tersimpan.');
      }
    } else {
      _showMessage(context, 'Payment Failed', 'Data tidak tersimpan.');
    }
  }

  void _showMessage(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
