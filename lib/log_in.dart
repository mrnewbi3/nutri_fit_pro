// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutri_fit_pro/auth/firebase_auth_implementation/firebase_auth_service.dart'; 

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 1),
                    Image.asset(
                      'assets/images/log_in.jpg',
                      height: 220,
                      width: 220,
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      "Sign-in",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 2),
                    _buildEmailInput(context),
                    const SizedBox(height: 19),
                    _buildPasswordInput(context),
                    const SizedBox(height: 2),
                    _buildForgotPassword(context),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 250,
                      child: FloatingActionButton(
                      onPressed: () {
                    _signIn(); // Call the _signIn method
                 },
                backgroundColor: const Color(0xFFD4E697),
                elevation: 4, // Add elevation for shadow effect
                child: Container(
                 width: 250,
                  height: 50,
                 decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                        ),
               child: const Center(
                 child: Text(
                  "Log in",
                style: TextStyle(fontSize: 25, color: Colors.white),
           ),
         ),
       ),
      )
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        onTapTxtDonthaveanaccount(context);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Don’t have an Account? ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: "Sign up",
                              style: const TextStyle(
                                color: Color(0xFFFEC71C),
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  onTapTxtSignup(context);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Email"),
          const SizedBox(height: 6),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: "Your email",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Password"),
          const SizedBox(height: 6),
          TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: "Password",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 21, top: 8),
      child: GestureDetector(
        onTap: () {
          _sendPasswordResetEmail(); // Call the method to send password reset email
        },
        child: const Text(
          "Forgot password?",
          style: TextStyle(
            color: Color.fromARGB(255, 243, 145, 33),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _signIn() async {
  if (_formKey.currentState!.validate()) {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      // Sign in the user with email and password
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        print("User successfully signed in");
        Navigator.pushNamed(context, "/homepage");
      } else {
        // Handle case where user object is null
        print("User object is null");
      }
    } catch (e) {
      // Handle specific exceptions thrown by Firebase Auth
      print("Error signing in: $e");

      // Check if the error message contains a specific substring
      if (e.toString().contains('wrong-password')) {
        // Show password error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid password. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Show a generic error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}



  void onTapTxtDonthaveanaccount(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  void onTapTxtSignup(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  void _sendPasswordResetEmail() async {
    String email = emailController.text;

    try {
      await _auth.sendPasswordResetEmail(email);
      // Show success message or navigate to a success screen
      print("Password reset email sent successfully");
    } catch (e) {
      // Handle errors, such as invalid email or user not found
      print("Error sending password reset email: $e");
    }
  }
}
