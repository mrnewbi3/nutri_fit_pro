class Food {
  final String foodName;
  final String imagePath;
  final Map<String, String> nutritionalContents;
  final String weights;

  Food({required this.foodName, required this.imagePath, required this.nutritionalContents, required this.weights});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodName: json['foodName'],
      imagePath: json['imagePath'],
      nutritionalContents: Map<String, String>.from(json['nutritionalContents']),
      weights: json['weights'],
    );
  }
}
