// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nutri_fit_pro/auth/firebase_auth_implementation/firebase_auth_service.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool termsAndPrivacySection = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final FirebaseAuthService _auth = FirebaseAuthService(); // Updated: Use the correct method names

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isButtonEnabled() {
    return userNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        termsAndPrivacySection;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
                    child: Row(
                      children: [
                        Text(
                          "Create Account",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Signika', color: Color.fromARGB(255, 0, 0, 0)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Username", style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 2),
                          TextFormField(
                            controller: userNameController,
                            decoration: const InputDecoration(
                              hintText: "Your username",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text("Email", style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 2),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: "Your email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text("Create a password", style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 2),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: "Must be 8 characters",
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text("Confirm password", style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 2),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              hintText: "Repeat password",
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          GestureDetector(
                            onTap: () {
                              _showTermsAndConditionsDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: termsAndPrivacySection,
                                  onChanged: (value) {
                                    setState(() {
                                      termsAndPrivacySection = value ?? false;
                                    });
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    "Terms and Privacy policy",
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 14,
                                      color: const Color(0xFFED7A0D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: FloatingActionButton(
                              onPressed: _isLoading ? null : () => _signUp(context),
                              backgroundColor: isButtonEnabled() ? const Color(0xFFD4E697) : Colors.grey,
                              child: _isLoading
                                  ? const SpinKitThreeInOut(color: Colors.white, size: 20)
                                  : const Text(
                                      "Sign Up",
                                      style: TextStyle(fontSize: 20, fontFamily: 'Signika', fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already Have An Account?",
                                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Text(
                                  " Log in",
                                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 243, 145, 33)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
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

  Future<void> _showTermsAndConditionsDialog(BuildContext context) async {
    String termsAndConditionsText = await rootBundle.loadString('assets/terms_and_conditions.txt');

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Privacy Policy'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(termsAndConditionsText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Accept',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _signUp(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Passwords do not match"),
        ));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        // Call signUpWithEmailAndPassword method from FirebaseAuthService
        await _auth.signUpWithEmailAndPassword(email, password); // Updated: Use the correct method name

        // Save username to Firestore
        await FirebaseFirestore.instance.collection('users').doc(_auth.getCurrentUser()!.uid).set({
          'username': userNameController.text.trim(),
          // Add more user information here if needed
        });

        // Navigate to home page after successful sign-up
        Navigator.pushNamed(context, "/homepage");
      } catch (e) {
        print("Error signing up: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error signing up: $e"),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
