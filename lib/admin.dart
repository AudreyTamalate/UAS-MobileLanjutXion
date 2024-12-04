import 'package:flutter/material.dart';
import 'addFilm.dart';
import 'addSchedule.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final String _correctPassword = "123";
  bool _isAuthenticated = false;
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = "";

  void _authenticate() {
    if (_passwordController.text == _correctPassword) {
      setState(() {
        _isAuthenticated = true;
        _errorMessage = "";
      });
    } else {
      setState(() {
        _errorMessage = "Password salah. Silakan coba lagi.";
      });
    }
  }

  void _logout() {
    setState(() {
      _isAuthenticated = false;
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Login'),
        ),
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login.jpg'), // Path to your login.jpg
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Login Form
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8), // Black background with transparency
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Masukkan Password untuk Akses Admin:',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white), // Teks putih di TextField
                          decoration: InputDecoration(
                            filled: true, // Mengaktifkan warna latar belakang
                            fillColor: Colors.black, // Warna latar belakang hitam
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8), // Membuat sudut membulat
                              borderSide: BorderSide.none, // Menghapus garis border
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white70), // Warna teks label abu-abu
                            errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White button background
                          ),
                          onPressed: _authenticate,
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.black), // Text color
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White button background
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Navigate back to user login
                          },
                          child: const Text(
                            'Kembali ke Halaman Pengguna',
                            style: TextStyle(color: Colors.black), // Text color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/admin.jpg'), // Path to your admin.jpg
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8), // Black background with some transparency
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Admin!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Add Film Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White button color
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddFilmPage()),
                      );
                    },
                    child: const Text(
                      'Manage Film',
                      style: TextStyle(color: Colors.black), // Text color
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Add Schedule Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White button color
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddSchedulePage()),
                      );
                    },
                    child: const Text(
                      'Manage Schedule',
                      style: TextStyle(color: Colors.black), // Text color
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Logout Button at Bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White button background
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _logout,
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.black), // Text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
