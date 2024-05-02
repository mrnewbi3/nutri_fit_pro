// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:nutri_fit_pro/search_result.dart';

class Food {
  final String foodName;
  final String imagePath;
  final String weights;
  final Map<String, String> nutritionalContents;

  Food({
    required this.foodName,
    required this.imagePath,
    required this.weights,
    required this.nutritionalContents,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodName: json['foodName'],
      imagePath: json['imagePath'],
      weights: json['weights'],
      nutritionalContents: Map<String, String>.from(json['nutritionalContents']),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Food> favoriteFoods = []; // List of favorite foods
  List<Food> allFoods = []; // List of all foods

  @override
  void initState() {
    super.initState();
    _loadFoods(); // Load foods when the screen initializes
    _loadFavorites(); // Load favorites from Firestore
  }

  Future<void> _loadFavorites() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final favoritesSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('favorites').get();

      setState(() {
        favoriteFoods = favoritesSnapshot.docs.map((doc) => Food(
          foodName: doc['foodName'],
          imagePath: doc['imagePath'],
          weights: doc['weights'],
          nutritionalContents: Map<String, String>.from(doc['nutritionalContents']),
        )).toList();
      });
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> _loadFoods() async {
    try {
      String jsonString = await rootBundle.loadString('assets/foods.json'); // Load JSON file
      List<dynamic> jsonList = json.decode(jsonString); // Decode JSON string to a list
      List<Food> loadedFoods = jsonList.map((json) => Food.fromJson(json)).toList(); // Map JSON objects to Food objects
      setState(() {
        allFoods = loadedFoods; // Update the state with all foods
      });
    } catch (e) {
      print('Error loading foods: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Food> filteredFavorites = favoriteFoods
        .where((food) =>
        food.foodName.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50.0,
                  width: 340,
                  margin: const EdgeInsets.only(bottom: 10, top: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 214, 213, 213),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search Foods...',
                            hintStyle: TextStyle(fontSize: 16),
                            contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          onSubmitted: (value) {
                            _search(value.trim());
                          },
                        ),
                      ),
                      Visibility(
                        visible: _searchController.text.isNotEmpty,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.clear, color: Color.fromARGB(255, 228, 155, 19)),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildYouMightLikeSection(allFoods),
                const SizedBox(height: 2),
                _buildFavoritesSection(filteredFavorites),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYouMightLikeSection(List<Food> foods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('You might like'), // "You might like" section comes first now
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              return GestureDetector( // Added GestureDetector for making cards clickable
                onTap: () {
                  _showFoodDetails(foods[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildFoodCard(foods[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesSection(List<Food> foods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Favorites'),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showFoodDetails(foods[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildFoodCard(foods[index]),
                ),
              );
            },
          ),
        ),
        if (foods.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'No favorite foods found.',
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Widget _buildFoodCard(Food food) {
    return GestureDetector(
      onTap: () {
        _showFoodDetails(food);
      },
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 249, 232),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(8), // Set bottom left corner radius to 0
            bottomRight: Radius.circular(8),
          ),
          border: Border.all(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage(food.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              food.foodName,
              style: const TextStyle(fontSize: 15, fontFamily: 'Signika', fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Align the text to center
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodDetails(Food food) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox( // Wrap the food name with a SizedBox to allow wrapping
                              width: 200, // Adjust the width as needed
                              child: Text(
                                food.foodName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2, // Limit the number of lines to 2
                              ),
                            ),
                            IconButton(
                              icon: favoriteFoods.contains(food) ? const Icon(Icons.favorite, color: Color.fromARGB(255, 243, 145, 33)) : const Icon(Icons.favorite_border),
                              onPressed: () {
                                _addToFavorites(food);
                                Navigator.of(context).pop(); // Close the AlertDialog after adding to favorites
                              },
                            ),
                          ],
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

      if (docSnapshot.exists) {
        await favoritesRef.doc(food.foodName).delete();
        setState(() {
          favoriteFoods.remove(food); // Remove from local list immediately
        });
      } else {
        await favoritesRef.doc(food.foodName).set({
          'foodName': food.foodName,
          'imagePath': food.imagePath,
          'weights': food.weights,
          'nutritionalContents': food.nutritionalContents,
        });
        setState(() {
          favoriteFoods.add(food); // Add to local list immediately
        });
      }
    } catch (e) {
      print('Error adding/removing favorite: $e');
    }
  }

  void _search(String searchTerm) async {
    if (searchTerm.isNotEmpty) {
      final selectedFood = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(searchTerm: searchTerm),
        ),
      );

      if (selectedFood != null && !favoriteFoods.contains(selectedFood)) {
        setState(() {
          favoriteFoods.add(selectedFood); // Add selected food to favorites
          _addToFavorites(selectedFood); // Save to Firestore
        });
      }
    }
  }
}
