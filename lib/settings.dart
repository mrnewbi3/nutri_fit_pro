import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication
import 'log_in.dart'; // Import the login screen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20), 
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 0),
                  child: Text(
                    'NUTRIFITPRO',
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false, // Remove the back button
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Column(
              children: [
                SizedBox(
                  height: 250, // Adjusted height
                  width: 213,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/images/profile.jpg'),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Removed Consumer<UsernameProvider> and usernameProvider references
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                _buildSettingsRow(context, settings: "Edit Profile", icon: Icons.edit),
                const SizedBox(height: 40),
                _buildSettingsRow(context, settings: "Settings", icon: Icons.settings),
                const SizedBox(height: 40),
                _buildSettingsRow(context, settings: "Terms & Privacy Policy", icon: Icons.privacy_tip),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut(); // Log out the user
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInScreen())); // Navigate to login screen without ability to go back
                  },
                  child: _buildSettingsRow(context, settings: "Log Out", icon: Icons.logout),
                ),
                const SizedBox(height: 5)
              ],
            ),
          ),
        ),
        bottomNavigationBar: const SizedBox.shrink(), // Removed the bottom navigation bar
      ),
    );
  }

  Widget _buildSettingsRow(
    BuildContext context, {
    required String settings,
    required IconData icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Icon(icon), // Icon on the left side
              const SizedBox(width: 8), // Adjusted SizedBox width for uniform gap
              Text(
                settings,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        const Spacer(), 
        Visibility(
          visible: !(settings == "Terms & Privacy Policy" || settings == "Log Out"),
          child: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: ProfileScreen(),
    ),
  );
}
