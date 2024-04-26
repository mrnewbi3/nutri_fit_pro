// Importing the Firestore package to interact with Firestore database
import 'package:cloud_firestore/cloud_firestore.dart';

// Defining a function that returns a Future<String> (nullable) which represents the URL of a user's profile image
Future<String?> getUserProfileImageUrl(String userId) async {
  // Fetching a snapshot of the document corresponding to the given userId from the 'users' collection
  final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  // Checking if the document exists
  if (snapshot.exists) {
    // If the document exists, extracting the data from the snapshot
    final userData = snapshot.data() as Map<String, dynamic>;
    // Returning the URL of the user's profile picture from the userData map
    return userData['profile_picture'] as String?;
  } else {
    // If the document doesn't exist, returning null
    return null;
  }
}
