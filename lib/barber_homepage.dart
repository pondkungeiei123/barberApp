import 'package:finalprojectbarber/screen/barber/barber_dashboard.dart';
import 'package:finalprojectbarber/screen/home.dart';
import 'package:finalprojectbarber/screen/profile.dart';
import 'package:finalprojectbarber/screen/search.dart';
import 'package:finalprojectbarber/screen/work.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class barberHomePage extends StatefulWidget {
  const barberHomePage({Key? key}) : super(key: key);

  @override
  State<barberHomePage> createState() => _barberHomePageState();
}

// ignore: camel_case_types
class _barberHomePageState extends State<barberHomePage> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      BarberDashboard(),
      UserWork(),
      UserSearch(),
      UserProfile(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255,
            255), // Set the background color of the BottomNavigationBar
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(
            255, 253, 168, 94), // Set the color when item is selected
        unselectedItemColor: const Color.fromARGB(
            255, 197, 197, 197), // Set the color for unselected items
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Work'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
