// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class SearchResultScreen extends StatefulWidget {
  final String searchTerm;

  const SearchResultScreen({Key? key, required this.searchTerm}) : super(key: key);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class Food {
  final String foodName;
  final String weights;
  final Map<String, String> nutritionalContents;
  final String imagePath; // Added imagePath property

  Food({
    required this.foodName,
    required this.weights,
    required this.nutritionalContents,
    required this.imagePath,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodName: json['foodName'],
      weights: json['weights'],
      nutritionalContents: Map<String, String>.from(json['nutritionalContents']),
      imagePath: json['imagePath'], // Initialize imagePath from JSON
    );
  }
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<Food> foods = []; // List of foods loaded from JSON
  List<Food> favoriteFoods = []; // List to store favorite foods

  @override
  void initState() {
    super.initState();
    _loadFoods(); // Load foods when the screen initializes
  }

  Future<void> _loadFoods() async {
    try {
      String jsonString = await rootBundle.loadString('assets/foods.json'); // Load JSON file
      List<dynamic> jsonList = json.decode(jsonString); // Decode JSON string to a list
      List<Food> loadedFoods =
          jsonList.map((json) => Food.fromJson(json)).toList(); // Map JSON objects to Food objects
      setState(() {
        foods = loadedFoods; // Update the state with loaded foods
      });
    } catch (e) {
      print('Error loading foods: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Food> filteredFoods = foods
        .where((food) =>
            food.foodName.toLowerCase().contains(widget.searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for: ${widget.searchTerm}'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: filteredFoods.isNotEmpty
          ? ListView.builder(
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                return _buildSearchResultItem(context, filteredFoods[index]);
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_basket, size: 100, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text('No food found for "${widget.searchTerm}"'),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchResultItem(BuildContext context, Food food) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          _showFoodDetails(context, food);
        },
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  food.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${food.foodName} - ${food.weights}', // Display food name and weights
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: food.nutritionalContents.entries
                          .map(
                            (entry) => Text('${entry.key}: ${entry.value}'),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodDetails(BuildContext context, Food food) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: GestureDetector(
            onTap: () {
              // Do nothing on tap to prevent AlertDialog from closing
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 180,
                    margin: const EdgeInsets.only(left: 1),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        food.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.foodName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Weights: ${food.weights}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: food.nutritionalContents.entries
                              .map(
                                (entry) => Text('${entry.key}: ${entry.value}'),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          bool isFavorite = await _isFavorite(food);
                          if (isFavorite) {
                            _removeFromFavorites(food); // Remove food from favorites
                          } else {
                            _addToFavorites(food); // Add food to favorites
                          }
                          Navigator.pop(context); // Close the dialog
                          Navigator.pop(context); // Navigate back to the HomeScreen
                        },
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Color.fromARGB(255, 228, 155, 19), // Set color of the icon
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
void _addToFavorites(Food food) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    final favoritesRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('favorites');

    final docSnapshot = await favoritesRef.doc(food.foodName).get();

    if (!docSnapshot.exists) {
      await favoritesRef.doc(food.foodName).set({
        'foodName': food.foodName,
        'imagePath': food.imagePath,
        'weights': food.weights,
        'nutritionalContents': food.nutritionalContents,
      });

      // Update local state immediately
      setState(() {
        favoriteFoods.add(food);
      });
    }
  } catch (e) {
    print('Error adding to favorites: $e');
  }
}

void _removeFromFavorites(Food food) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    final favoritesRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('favorites');

    final docSnapshot = await favoritesRef.doc(food.foodName).get();

    if (docSnapshot.exists) {
      await favoritesRef.doc(food.foodName).delete();

      // Update local state immediately
      setState(() {
        favoriteFoods.remove(food);
      });
    }
  } catch (e) {
    print('Error removing from favorites: $e');
  }
}


  Future<bool> _isFavorite(Food food) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final favoritesRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('favorites');

      final docSnapshot = await favoritesRef.doc(food.foodName).get();

      return docSnapshot.exists;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }
}
