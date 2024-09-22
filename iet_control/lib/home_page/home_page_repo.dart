import 'package:firebase_database/firebase_database.dart';

class HomePageRepo {
  final DatabaseReference _dbUser = FirebaseDatabase.instance.ref('users');
  final DatabaseReference _dbDev = FirebaseDatabase.instance.ref('devices');

  // Function to fetch user data and device details
  void fetchUserData(String userId, Function(Map<dynamic, dynamic>) onDataUpdated) {
    // Listen to the user's data in real-time
    _dbUser.child(userId).onValue.listen((DatabaseEvent event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? userData = event.snapshot.value as Map<dynamic, dynamic>;

        if (userData.containsKey('devicesDetails') && userData['devicesDetails'] is List) {
          List<dynamic> deviceList = userData['devicesDetails'].where((device) => device != null).toList();

          Map<String, dynamic> deviceDetails = {};

          // Listen to real-time changes for each device's status and type
          for (var deviceId in deviceList) {
            _dbDev.child(deviceId).onValue.listen((deviceEvent) {
              if (deviceEvent.snapshot.value != null) {
                var deviceData = deviceEvent.snapshot.value as Map;
                deviceDetails[deviceId] = {
                  'status': deviceData['status'],
                  'type': deviceData['type'],
                };

                // Notify the UI whenever device data is updated
                userData['deviceDetails'] = deviceDetails;
                onDataUpdated(userData); // Call the callback function with updated data
              }
            });
          }
        } else {
          onDataUpdated(userData); // Notify the UI without device details if not found
        }
      } else {
        onDataUpdated({}); // Notify with an empty map if no data is found
      }
    });
  }

  // Function to update the status of a specific device
  Future<void> updateStatus(String key, bool status) async {
    try {
      await _dbDev.child(key).update({
        'status': status, // Update the status in devices table
      });
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
