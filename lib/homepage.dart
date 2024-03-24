import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home.dart';
import 'bmi_calcu.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BMICalculatorScreen(),
    const ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(255, 255, 255, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
          child: GNav(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            color: const Color.fromARGB(255, 4, 108, 16),
            activeColor: Colors.white,
            tabBackgroundColor: const Color.fromARGB(255, 46, 131, 7),
            gap: 2, // Adjust the gap value here
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconSize: 30,
                iconColor: const Color(0xFF91C788),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              GButton(
                icon: Icons.calculate,
                text: 'BMI Calculator',
                iconSize: 30,
                iconColor: const Color(0xFF91C788),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              GButton(
                icon: Icons.settings,
                iconSize: 30,
                iconColor: const Color(0xFF91C788),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Adjust horizontal padding here
                text: 'Settings',
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Add this line to adjust button position
          ),
        ),
      ),
    );
  }
}
