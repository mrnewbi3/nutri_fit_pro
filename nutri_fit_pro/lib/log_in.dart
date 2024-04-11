// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutri_fit_pro/auth/firebase_auth_implementation/firebase_auth_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  bool _isLoading = false;

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
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: double.infinity,
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
                          onPressed: _isLoading ? null : _signIn,
                          backgroundColor: const Color(0xFFD4E697),
                          elevation: 4,
                          child: Container(
                            width: 250,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "Log in",
                                      style: TextStyle(fontSize: 25, color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
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
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: SpinKitThreeInOut(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
          ],
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
          sendPasswordResetEmail();
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

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          print("User successfully signed in");
          Navigator.pushReplacementNamed(context, "/homepage");
        } else {
          print("User object is null");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please try again later.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid password. Please try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email not found. Please sign up.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
                    ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please try again later.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        print("Error signing in: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void sendPasswordResetEmail() async {
    String email = emailController.text;

    try {
      await _auth.sendPasswordResetEmail(email);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Password Reset"),
            content: Text("An email has been sent to $email for password resetting."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error sending password reset email: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending password reset email. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void onTapTxtDonthaveanaccount(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  void onTapTxtSignup(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }
}