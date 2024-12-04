import 'package:flutter/material.dart';
import 'payment.dart'; // Pastikan PaymentScreen sudah diimpor

class SeatScreen extends StatefulWidget {
  final String filmTitle;
  final String selectedDay;
  final String selectedTime;
  final String selectedStudio;

  const SeatScreen({
    super.key,
    required this.filmTitle,
    required this.selectedDay,
    required this.selectedTime,
    required this.selectedStudio,
  });

  @override
  SeatScreenState createState() => SeatScreenState();
}

class SeatScreenState extends State<SeatScreen> {
  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K']; // Baris kursi A-K
  final Set<String> _selectedSeats = {};
  final int ticketPrice = 40000;

  List<Widget> _buildRowSeats(String row) {
    List<Widget> seats = [];
    
    // Membagi kursi menjadi dua bagian: 1-5 kiri, 6-10 kanan
    for (int i = 1; i <= 5; i++) {
      String seatId = '$row$i';
      seats.add(
        GestureDetector(
          onTap: () {
            setState(() {
              if (_selectedSeats.contains(seatId)) {
                _selectedSeats.remove(seatId);
              } else {
                _selectedSeats.add(seatId);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _selectedSeats.contains(seatId) ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                seatId,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    // Menambahkan space antara 1-5 dan 6-10
    seats.add(const SizedBox(width: 20)); // Jarak antara sisi kiri dan kanan

    for (int i = 6; i <= 10; i++) {
      String seatId = '$row$i';
      seats.add(
        GestureDetector(
          onTap: () {
            setState(() {
              if (_selectedSeats.contains(seatId)) {
                _selectedSeats.remove(seatId);
              } else {
                _selectedSeats.add(seatId);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _selectedSeats.contains(seatId) ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                seatId,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: seats, // Semua kursi berada dalam satu baris
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = _selectedSeats.length * ticketPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Selection for ${widget.filmTitle}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Film: ${widget.filmTitle}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Day: ${widget.selectedDay}'),
            Text('Time: ${widget.selectedTime}'),
            Text('Studio: ${widget.selectedStudio}'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  String row = rows[index];
                  return Column(
                    children: _buildRowSeats(row),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 30,
              width: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Text(
                  'SCREEN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Menambahkan container lebih kecil untuk Total Price dan Confirm Selection
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  Text(
                    'Total Price: Rp ${totalPrice.toString()}',
                    style: const TextStyle(
                      fontSize: 14, // Ukuran font lebih kecil
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedSeats.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('No Seats Selected'),
                                  content: const Text('Please select at least one seat to proceed.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Selected Seats'),
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Seats: ${_selectedSeats.join(', ')}',
                                        style: const TextStyle(fontSize: 20), // Ukuran teks lebih kecil
                                      ),
                                      Text(
                                        'Total Price: Rp ${totalPrice.toString()}',
                                        style: const TextStyle(fontSize: 20), // Ukuran teks lebih kecil
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentScreen(
                                              selectedSeats: _selectedSeats.toList(),
                                              totalPrice: totalPrice,
                                              selectedDay: widget.selectedDay,
                                              selectedTime: widget.selectedTime,
                                              selectedStudio: widget.selectedStudio,
                                              filmTitle: widget.filmTitle,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text('Confirm Selection'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
