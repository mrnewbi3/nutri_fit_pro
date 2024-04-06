import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication
//import 'log_in.dart'; // Import the login screen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SizedBox(height: 40),
              _buildRoundedButton(context, settings: "Edit Profile",icon: Icons.edit, iconColor: const Color.fromARGB(255, 108, 134, 23), showArrow: false),
              const SizedBox(height: 20),
              _buildRoundedButton(context, settings: "About", icon: Icons.info_outline, iconColor: const Color.fromARGB(255, 204, 159, 23), showArrow: false),
              const SizedBox(height: 20),
              _buildRoundedButton(context, settings: "Terms & Privacy Policy", icon: Icons.description_outlined, iconColor: const Color(0xFFED7A0D)),
              const SizedBox(height: 20),
              _buildRoundedButton(context, settings: "Log Out", icon: Icons.logout, iconColor: const Color.fromARGB(255, 226, 64, 0)),
              const SizedBox(height: 5)
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SizedBox.shrink(), // Removed the bottom navigation bar
    );
  }

  Widget _buildRoundedButton(
    BuildContext context, {
    required String settings,
    required IconData icon,
    Color iconColor = Colors.black,
    bool showArrow = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 233, 233),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          if (settings == "Log Out") {
            FirebaseAuth.instance.signOut(); // Log out the user
            Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen without ability to go back
          } else if (settings == "Terms & Privacy Policy") {
            // Show Terms & Privacy Policy dialog
            showDialog(
              context: context,
              builder: (context) => _buildTermsAndPrivacyDialog(context),
            );
          } else if (settings == "Edit Profile") {
            // Handle Edit Profile action
            // You can add specific actions for Edit Profile here
          } else if (settings == "About") {
            // Show About dialog
            showDialog(
              context: context,
              builder: (context) => _buildAboutDialog(context),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                settings,
                style: TextStyle(fontSize: 16, color: iconColor),
              ),
              const Spacer(),
              // Removed Visibility widget that wraps the arrow icon
              showArrow ? const Icon(Icons.arrow_forward_ios) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacyDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Terms & Privacy Policy", style: TextStyle(fontFamily: 'Poppins', fontSize: 25, color: Color(0xFFED7A0D)),),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Terms and Privacy Policy",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Welcome to NutriFitPro!\n\n"
              "These terms outline the rules and regulations for the use of NutriFitPro's mobile application.\n\n"
              "**Privacy Policy**\n\n"
              "Your privacy is important to us. It is NutriFitPro's policy to respect your privacy regarding any information we may collect while operating our mobile application. This Privacy Policy describes how we collect, use, and disclose your information when you use our mobile application and the choices you have associated with that information.\n\n"
              "**Information Collection and Use**\n\n"
              "We do not collect any personal information. However, NutriFitPro may use third-party services that may collect information used to identify you.\n\n"
              "**Log Data**\n\n"
              "We want to inform you that whenever you use our mobile application, in a case of an error in the app, we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our mobile application, the time and date of your use of the mobile application, and other statistics.\n\n"
              "**Links to Other Sites**\n\n"
              "Our mobile application may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.\n\n"
              "**Children's Privacy**\n\n"
              "These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions.\n\n"
              "**Terms of Use**\n\n"
              "By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trade marks, copyright, database rights, and other intellectual property rights related to it, still belong to NutriFitPro.\n\n"
              "**Changes to This Terms and Privacy Policy**\n\n"
              "We may update our Terms and Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms and Privacy Policy on this page.\n\n"
              "**Contact Us**\n\n"
              "If you have any questions or suggestions about our Terms and Privacy Policy, do not hesitate to contact us at contact@nutrifitpro.com.\n\n",
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Close",
            style: TextStyle(color: Color(0xFFED7A0D), fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutDialog(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text("About", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 25, color: Color(0xFFCC9F17)),)),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "NutriFitPro",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Version: 1.0.0\n\n"
              "Developers: NutriFitPro Team\n\n"
              "Description: NutriFitPro is a mobile application designed to help users track their nutrition intake, plan meals, and achieve their health and fitness goals. With NutriFitPro, users can easily log their meals, monitor calorie intake, and access a database of nutritious recipes. Whether you're looking to lose weight, gain muscle, or simply maintain a healthy lifestyle, NutriFitPro provides the tools and resources you need to succeed.\n\n",
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Close",
            style: TextStyle(color: Color(0xFFCC9F17), fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
