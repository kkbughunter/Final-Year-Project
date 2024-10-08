import 'dart:async';
import 'package:firebase_database/firebase_database.dart';


class HomePageRepo {
  final DatabaseReference _dbUser = FirebaseDatabase.instance.ref('users');
  final DatabaseReference _dbDev = FirebaseDatabase.instance.ref('devices');

  // Fetch user data and listen to updates
  void fetchUserData(String userId, Function(Map<dynamic, dynamic>) onDataUpdated) {
    _dbUser.child(userId).onValue.listen((DatabaseEvent event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> userData = event.snapshot.value as Map<dynamic, dynamic>;
        List<dynamic> deviceList = [];

        if (userData['deviceDetails'] == null) {
          userData['deviceDetails'] = {};
          onDataUpdated(userData);
          return;
        }

        // Handle both Map and List cases for deviceDetails
        if (userData['deviceDetails'] is Map) {
          deviceList = (userData['deviceDetails'] as Map)
              .values
              .where((device) => device != null)
              .toList();
        } else if (userData['deviceDetails'] is List) {
          deviceList = userData['deviceDetails']
              .where((device) => device != null)
              .toList();
        }

        if (userData.containsKey('deviceDetails') && deviceList.isNotEmpty) {
          Map<String, dynamic> deviceDetails = {};
          userData['deviceDetails'] = deviceDetails;
          onDataUpdated(userData);

          // Listen for changes in each device in the list
          for (var deviceId in deviceList) {
            if (deviceId != null) {
              _dbDev.child(deviceId).onValue.listen((DatabaseEvent deviceEvent) {
                if (deviceEvent.snapshot.value != null) {
                  var deviceData = deviceEvent.snapshot.value as Map<dynamic, dynamic>;

                  // Extract device status and type
                  bool status = deviceData['status'] ?? false;
                  String type = deviceData['type'] ?? 'Unknown';

                  // Update device details incrementally
                  deviceDetails[deviceId] = {
                    'status': status,
                    'type': type,
                  };

                  // Update UI with the updated device details
                  userData['deviceDetails'] = deviceDetails;
                  onDataUpdated(userData); // Notify UI with updates
                }
              }).onError((error) {
                print("Error listening to device $deviceId: $error");
              });
            }
          }
        } else {
          userData['deviceDetails'] = {};
          onDataUpdated(userData); // No devices found
        }
      } else {
        onDataUpdated({}); // No user data found
      }
    });
  }

  // Update device status in Firebase
  Future<void> updateStatus(String key, bool status) async {
    try {
      await _dbDev.child(key).update({
        'status': status,
      });
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
