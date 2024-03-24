// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nutri_fit_pro/on_boarding.dart';
import 'package:nutri_fit_pro/log_in.dart';
import 'package:nutri_fit_pro/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
  try {
    // Delay for 5 seconds to display the splash screen
    await Future.delayed(const Duration(seconds: 5));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstInstall = prefs.getBool('isFirstInstall') ?? true;

    print('isFirstInstall: $isFirstInstall');

    if (isFirstInstall) {
  // Navigate to OnboardingScreen
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const OnboardingScreen()),
  );
} else {
  // Check user login status and navigate accordingly
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // User is not logged in, navigate to LogInScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LogInScreen()),
    );
  } else {
    // User is logged in, navigate to HomePage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}

  } catch (e) {
    print('Error navigating to next screen: $e');
    // Handle error (e.g., show an error dialog)
  }
}


  @override
  Widget build(BuildContext context) {
    // Define the background color
    const backgroundColor = Color(0xFFD4E697);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 750,
          height: 750,
        ),
      ),
    );
  }
}
