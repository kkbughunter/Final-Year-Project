import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iet_control/auth/phone_number_page.dart';

class ProfileRepo {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Fetch user profile data from Firebase Realtime Database
  Future<Map<String, dynamic>> fetchProfileData() async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    // Reference to user-specific data under 'users'
    final DatabaseReference profileRef = _dbRef.child('users/${user.uid}');

    // Fetching data once
    final snapshot = await profileRef.once();
    if (snapshot.snapshot.value != null) {
      final profileData =
          Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return profileData;
    } else {
      throw Exception("Profile data not found");
    }
  }

  static Future<void> logout(BuildContext context) async {
    await _auth.signOut();

    // Navigate to PhoneNumberPage after logging out
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PhoneNumberPage()),
      (Route<dynamic> route) => false, // Removes all the previous routes
    );
  }
}
