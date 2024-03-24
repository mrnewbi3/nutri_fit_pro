// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutri_fit_pro/auth/firebase_auth_implementation/firebase_auth_service.dart';

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

  final FirebaseAuthService _auth = FirebaseAuthService();

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
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
                child: Row(
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Signika', color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(width: 1),
                    Image.asset(
                      'assets/images/sign.jpg',
                      height: 130,
                      width: 130,
                    ),
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
                      Row(
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
                              "I accept the terms and privacy policy",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FloatingActionButton(
                          onPressed: isButtonEnabled() ? _signUp : null,
                          backgroundColor: isButtonEnabled() ? const Color(0xFFD4E697) : Colors.grey,
                          child: const Text(
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
      ),
    );
  }

  onTapCreateAccount(BuildContext context) {
    Navigator.pushNamed(context, '/homepage');
  }

  onTapTxtAlreadyhavean(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      if (password != confirmPassword) {
        // Show an error message indicating that passwords do not match
        return;
      }

      try {
        User? user = await _auth.signUpwithEmailAndPassword(email, password);
        if (user != null) {
          print("User successfully created");
          Navigator.pushNamed(context, "/homepage");
        } else {
          // Handle case where user object is null
          print("User object is null");
        }
      } catch (e) {
        // Handle specific exceptions thrown by Firebase Auth
        print("Error signing up: $e");
      }
    }
  }
}
