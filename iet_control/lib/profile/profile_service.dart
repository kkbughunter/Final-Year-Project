import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileService {
  User? user = FirebaseAuth.instance.currentUser;

  // Updated to access user-specific data under 'users'
  final DatabaseReference _profileRef = FirebaseDatabase.instance
      .ref('users/${FirebaseAuth.instance.currentUser?.uid}');

  Future<Map<String, dynamic>> fetchProfileData() async {
    final snapshot = await _profileRef.once();
    if (snapshot.snapshot.value != null) {
      final profileData =
          Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return profileData;
    } else {
      throw Exception("Profile data not found");
    }
  }
}
