// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:nutri_fit_pro/sign_up.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 0),
                  child: Text(
                    'NUTRIFITPRO',
                    style: TextStyle(fontSize: 25, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Set your Goals",
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontSize: 25, // Absolute font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/img_goals.png",
                    height: screenWidth * 0.4, // Responsive size
                    width: screenWidth * 0.4, // Responsive size
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Unlock wellness\n"
                        "through nutrition.\n"
                        "Set goals for a\n"
                        "transformative\n"
                        "journey. ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontSize: screenWidth * 0.05, // Responsive font size
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const EmbraceHealthyEatingWidget(),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 80),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    backgroundColor: const Color(0xFFD4E697),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Signika'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class EmbraceHealthyEatingWidget extends StatelessWidget {
  const EmbraceHealthyEatingWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Embrace ",
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontSize: 25, // Absolute font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Healthy Eating",
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontSize: 25, // Absolute font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Discover a healthier,\n"
                    "   happier you by\n"
                    " harnessing the\n"
                    "  benefits of\n"
                    "   nutrition.\n",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontSize: 20, // Absolute font size
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
            Image.asset(
              "assets/images/img_eat.png",
              height: screenWidth * 0.4, // Responsive size
              width: screenWidth * 0.4, // Responsive size
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
