import 'package:flutter/material.dart';
import 'login.dart';
import 'film.dart';
import 'studio.dart';
import 'history.dart';
import 'admin.dart'; // Pastikan file admin_page.dart sudah dibuat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XION Cinema',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white70,
        ),
      ),
      home: const LoginScreen(), // Start with the login screen
    );
  }
}

class XIONCinemaApp extends StatefulWidget {
  const XIONCinemaApp({super.key});

  @override
  XIONCinemaAppState createState() => XIONCinemaAppState();
}

class XIONCinemaAppState extends State<XIONCinemaApp> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const FilmScreen(),
    StudioScreen(),
    const HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Logout function to navigate to the login screen
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XION Cinema'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Film Selection', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                  Navigator.pop(context); // Close the drawer
                });
              },
            ),
            ListTile(
              title: const Text('Studio Selection', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                  Navigator.pop(context); // Close the drawer
                });
              },
            ),
            ListTile(
              title: const Text('Purchase History', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                  Navigator.pop(context); // Close the drawer
                });
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
              title: const Text('Admin Page', style: TextStyle(color: Colors.white)), // Navigasi ke halaman admin
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPage()),
                );
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                _logout(context); // Call logout function
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Films',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
