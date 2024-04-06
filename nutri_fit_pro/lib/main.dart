import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_fit_pro/splash.dart';
import 'package:nutri_fit_pro/sign_up.dart';
import 'package:nutri_fit_pro/log_in.dart';
import 'package:nutri_fit_pro/homepage.dart';
import 'package:nutri_fit_pro/on_boarding.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'username_provider.dart'; // Import the UsernameProvider class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase(); // Call the function to initialize Firebase
  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA5YJReS5rtzbl5upur5LgwgRnjgxRS8Fk',
        appId: '1:237412426748:android:106db07cc6a74950068879',
        messagingSenderId: '237412426748',
        projectId: 'nutrifitpro-f6cfc',
      ),
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Wrap MaterialApp with MultiProvider
      providers: [
        ChangeNotifierProvider(create: (_) => UsernameProvider()), // Provide the UsernameProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        routes: {
          '/signup': (context) => const SignUpScreen(),
          '/homepage': (context) => const HomePage(),
          '/login': (context) => const LogInScreen(),
          '/splash': (context) => const SplashScreen(),
          '/on_boarding': (context) => const OnboardingScreen(),
        },
        initialRoute: '/splash', // Set the initial route to splash screen
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            if (settings.name == '/splash') {
              return const SplashScreen();
            } else {
              return FutureBuilder<bool>(
                future: _checkLoggedIn(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  // If user is logged in, navigate to HomePage
                  if (snapshot.hasData && snapshot.data == true) {
                    return const HomePage();
                  } else {
                    // Otherwise, navigate to LogInScreen
                    return const LogInScreen();
                  }
                },
              );
            }
          });
        },
      ),
    );
  }

  Future<bool> _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }
}
