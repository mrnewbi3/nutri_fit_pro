import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({Key? key}) : super(key: key);

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}
 // Add Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  double bmiResult = 0.0;
  String bmiStatus = '';
  double maintenanceCalorieIntake = 0.0;
  double weightLossCalorieIntake = 0.0;
  double weightGainCalorieIntake = 0.0;
  bool isCalculationDone = false;
  Gender selectedGender = Gender.male; // Initialize with a non-nullable value

  String weightUnit = 'kg'; // Default weight unit
  String heightUnit = 'cm'; // Default height unit
  bool isCalculatingBMI = false; // Track if BMI calculation is in progress

  void calculateBMI() {
    String weightText = weightController.text.trim();
    String heightText = heightController.text.trim();
// Assuming you have access to the user's ID, replace 'user_id' with the actual user ID
String userId = FirebaseAuth.instance.currentUser!.uid;

  // Check if the document exists before updating it
_firestore.collection('users').doc(userId).get().then((DocumentSnapshot document) {
  if (document.exists) {
    // Document exists, update its fields
    _firestore.collection('users').doc(userId).update({
      'bmiResult': bmiResult.toStringAsFixed(2),
      'bmiStatus': bmiStatus,
      // Add other preferences here if needed
    });
  } else {
    // Document doesn't exist, create it with the required fields
    _firestore.collection('users').doc(userId).set({
      'bmiResult': bmiResult.toStringAsFixed(2),
      'bmiStatus': bmiStatus,
      // Add other preferences here if needed
    });
  }
}).catchError((error) {
  // Handle any errors that occur during the process
  print("Error: $error");
});

  

    if (weightText.isEmpty || heightText.isEmpty) {
      // Show alert dialog if any field is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Error",
              style: TextStyle(color: Colors.red, fontSize: 25.0, fontFamily: 'Signika', fontWeight: FontWeight.bold),
            ),
            content: const Text("Please input weight and height before calculating BMI."),
            contentTextStyle: const TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'Signika'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Signika', color: Colors.blue),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    double weight = double.tryParse(weightText) ?? 0.0;
    double height = double.tryParse(heightText) ?? 0.0;

    // Convert weight to kg if unit is pounds
    if (weightUnit == 'lb') {
      weight *= 0.453592; // 1 lb = 0.453592 kg
    }

    // Convert height to cm if unit is foot/inches
    if (heightUnit == 'ft/in') {
      double feet = height.floorToDouble();
      double inches = (height - feet) * 12;
      height = (feet * 30.48) + (inches * 2.54); // 1 foot = 30.48 cm, 1 inch = 2.54 cm
    }

    if (weight > 0 && height > 0) {
      // Set isCalculatingBMI to true to indicate calculation is in progress
      setState(() {
        isCalculatingBMI = true;
      });

      // BMI Calculation
      double bmi = weight / ((height / 100) * (height / 100));

      // Determine BMI status
      if (bmi < 18.5) {
        bmiStatus = 'Underweight';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        bmiStatus = 'Normal';
      } else if (bmi >= 25 && bmi < 29.9) {
        bmiStatus = 'Overweight';
      } else {
        bmiStatus = 'Obese';
      }

      // Calculate suggested daily calorie intake
      double basalMetabolicRate = 10 * weight + 6.25 * height - 5 * 25; // Assuming age of 25
      maintenanceCalorieIntake = basalMetabolicRate * 1.2;
      weightLossCalorieIntake = basalMetabolicRate * 0.8;
      weightGainCalorieIntake = basalMetabolicRate * 1.4;

      // Update state with calculated BMI
      setState(() {
        bmiResult = bmi;
        isCalculationDone = true;
        isCalculatingBMI = false; // Set to false when calculation is done
      });
      // After calculating BMI, set the BMI result in the UsernameProvider
      //Provider.of<UsernameProvider>(context, listen: false).setBMIResult('BMI: ${bmiResult.toStringAsFixed(2)} | $bmiStatus');
    }
  }

  void resetCalculation() {
  // Show confirmation dialog before resetting
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Wait..",
          style: TextStyle(fontFamily: 'Signika',
            color: Colors.blue, // Customize title text color
            fontSize: 20.0, // Customize title font size
            fontWeight: FontWeight.bold, // Customize title font weight
          ),
        ),
        content: const Text(
          "Are you sure you want to recal-\n"
          "culate BMI? Or save the result\n"
          "to your Profile?",
          style: TextStyle(
            color: Colors.black, // Customize content text color
            fontSize: 16.0, // Customize content font size
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              "Save BMI",
              style: TextStyle(
                color: Colors.red, // Customize button text color
                fontSize: 18.0, // Customize button font size
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Reset BMI calculation and fields
              setState(() {
                isCalculationDone = false;
                weightController.text = '';
                heightController.text = '';
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              "Recalculate",
              style: TextStyle(
                color: Colors.green, // Customize button text color
                fontSize: 18.0, // Customize button font size
              ),
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.black; // Default color for status text
    Color bmiResultColor = Colors.black; // Default color for BMI result text

    if (isCalculationDone) {
      // Set color based on BMI status
      switch (bmiStatus) {
        case 'Underweight':
          statusColor = const Color(0xFFFEC71C);
          break;
        case 'Normal':
          statusColor = const Color(0xFF6CB663);
          break;
        case 'Overweight':
          statusColor = const Color(0xFFED7A0D);
          break;
        case 'Obese':
          statusColor = const Color.fromARGB(255, 153, 7, 7);
          break;
        default:
          statusColor = Colors.black; // Default color
          break;
      }

      // Set color for BMI result
      if (bmiResult < 18.5) {
        bmiResultColor = const Color(0xFFFEC71C);
      } else if (bmiResult >= 18.5 && bmiResult < 24.9) {
        bmiResultColor = const Color(0xFF6CB663);
      } else if (bmiResult >= 25 && bmiResult < 29.9) {
        bmiResultColor = const Color(0xFFED7A0D);
      } else {
        bmiResultColor = const Color.fromARGB(255, 153, 7, 7);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 10),
                child: Text(
                  isCalculationDone ? 'BMI Calculator' : 'NUTRIFITPRO',
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isCalculationDone)
                Row(
                  children: [
                    Expanded(
                      child: _buildWeightField(),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              if (!isCalculationDone)
                Row(
                  children: [
                    Expanded(
                      child: _buildHeightField(),
                    ),
                  ],
                ),
              const SizedBox(height: 15.0),
              if (!isCalculationDone)
                Row(
                  children: [
                    const Text('  Gender:', style: TextStyle(fontSize: 16.0, fontFamily: 'Signika')),
                    const SizedBox(width: 30.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedGender = Gender.male;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: selectedGender == Gender.male ? const Color(0xFFED7A0D) : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.male, color: selectedGender == Gender.male ? Colors.white : const Color(0xFFED7A0D)),
                          const SizedBox(width: 12),
                          Text('Male', style: TextStyle(color: selectedGender == Gender.male ? Colors.white : const Color(0xFFED7A0D), fontSize: 17.0, fontFamily: 'Signika')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedGender = Gender.female;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: selectedGender == Gender.female ? const Color(0xFFED7A0D) : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.female, color: selectedGender == Gender.female ? Colors.white : const Color(0xFFED7A0D)),
                          const SizedBox(width: 5),
                          Text('Female', style: TextStyle(color: selectedGender == Gender.female ? Colors.white : const Color(0xFFED7A0D), fontSize: 17.0, fontFamily: 'Signika')),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 15.0),
              if (!isCalculationDone)
                FloatingActionButton.extended(
                  onPressed: isCalculatingBMI ? null : calculateBMI,
                  label: isCalculatingBMI ? const CircularProgressIndicator() : const Text(
                    'Calculate BMI',
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontSize: 18,
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 195, 214, 132),
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                ),
              const SizedBox(height: 2.0),
              if (isCalculationDone)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.fromLTRB(50.0, 2.0, 50.0, 10), // Adjust the top margin to 8.0
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'BMI Result: ',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, fontFamily: 'Signika'),
                                ),
                                Text(
                                  bmiResult.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, fontFamily: 'Signika', color: bmiResultColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Status: ',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, fontFamily: 'Signika'),
                                ),
                                Text(
                                  bmiStatus,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: statusColor, fontFamily: 'Signika'),
                                  textAlign: TextAlign.center, // Align status to the center
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSuggestedCalorieIntake('Maintenance', maintenanceCalorieIntake.toStringAsFixed(2)),
                          _buildSuggestedCalorieIntake('Losing Weight', weightLossCalorieIntake.toStringAsFixed(2)),
                          _buildSuggestedCalorieIntake('Gaining Weight', weightGainCalorieIntake.toStringAsFixed(2)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    FloatingActionButton.extended(
                      onPressed: resetCalculation,
                      label: const Text(
                        'Calculate Again',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'Montserrat'),
                      ),
                      backgroundColor: const Color.fromARGB(255, 195, 214, 132),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedCalorieIntake(String title, String value) {
    Color cardColor;

    switch (title) {
      case 'Maintenance':
        cardColor = const Color.fromARGB(255, 176, 231, 167);
        break;
      case 'Losing Weight':
        cardColor = const Color(0xFFFFF7E0);
        break;
      case 'Gaining Weight':
        cardColor = const Color.fromARGB(255, 235, 146, 63);
        break;
      default:
        cardColor = Colors.white; // Default color
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        color: cardColor,
        child: SizedBox(
          width: double.infinity, // Ensure the card takes the full width of the screen
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center, // Center the title text
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: 'Signika'),
                ),
                const SizedBox(height: 2.0), // Adjust as needed for spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Suggested Daily Calorie Intake: ',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: 'Signika'),
                    ),
                    Text(
                      value,
                      textAlign: TextAlign.start, // Center the value text
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: 'Signika'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.scale, color: Colors.grey[600]), // This line sets the icon
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                suffixIcon: DropdownButton<String>(
                  value: weightUnit,
                  onChanged: (String? value) {
                    setState(() {
                      weightUnit = value!;
                    });
                  },
                  items: <String>['kg', 'lb']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.straighten, color: Colors.grey[600]), // Icon for height
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          DropdownButton<String>(
            value: heightUnit,
            onChanged: (String? value) {
              setState(() {
                heightUnit = value!;
              });
            },
            items: <String>['cm', 'ft/in']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

enum Gender { male, female }

void main() {
  runApp(const MaterialApp(
    home: BMICalculatorScreen(),
  ));
}
