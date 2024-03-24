// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class FoodDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFoodItem({
    required String foodName,
    required int calorieContent,
    required int proteinContent,
    required int fatContent,
    required int carbsContent,
    required String imageUrl,
  }) async {
    try {
      // Add document with custom ID
      await _firestore.collection('foods').doc('foods_custom_id').set({
        'food_name': foodName,
        'calorie_content': calorieContent,
        'protein_content': proteinContent,
        'fat_content': fatContent,
        'carbs_content': carbsContent,
        'image_url': imageUrl,
      });
      print('Food item added successfully');
    } catch (e) {
      print('Error adding food item: $e');
    }
  }
}
