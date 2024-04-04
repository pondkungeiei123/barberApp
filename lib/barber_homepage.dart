import 'package:finalprojectbarber/screen/barber/barber_dashboard.dart';
import 'package:finalprojectbarber/screen/barber_profile_screen.dart';
import 'package:finalprojectbarber/screen/work_schedule_screen.dart';
import 'package:finalprojectbarber/screen/workings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_manager/data_manager.dart';

// ignore: camel_case_types
class BarberHomePage extends StatefulWidget {
  const BarberHomePage({super.key});

  @override
  State<BarberHomePage> createState() => _BarberHomePageState();
}

// ignore: camel_case_types
class _BarberHomePageState extends State<BarberHomePage> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String id = Provider.of<DataManagerProvider>(context, listen: false)
        .barberProfile
        .barberId;
    final List<Widget> pages = [
      BarberDashboard(),
      WorkSchedulePage(id: id),
      // UserSearch(),
      const WorkingsPage(),
      const BarberProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 253, 168, 94),
        unselectedItemColor: const Color.fromARGB(255, 197, 197, 197),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'ตารางงาน'),
          // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium), label: 'ผลงาน'),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: 'บัญชี'),
        ],
      ),
    );
  }
}
