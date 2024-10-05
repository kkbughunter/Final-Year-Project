import 'package:firebase_database/firebase_database.dart';

class HomePageRepo {
  final DatabaseReference _dbUser = FirebaseDatabase.instance.ref('users');
  final DatabaseReference _dbDev = FirebaseDatabase.instance.ref('devices');

  // Function to fetch user data and device details
  void fetchUserData(
      String userId, Function(Map<dynamic, dynamic>) onDataUpdated) {
    _dbUser.child(userId).onValue.listen((DatabaseEvent event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> userData =
            event.snapshot.value as Map<dynamic, dynamic>;
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
          print('Fetched Data 2: $userData');
          print("Devices: $deviceList");

          // Initialize an empty map for deviceDetails
          Map<String, dynamic> deviceDetails = {};

          // Notify UI that data is being fetched (for displaying loading indicators)
          userData['deviceDetails'] = deviceDetails;
          onDataUpdated(userData); // Update UI with an empty device list

          // Set up an active listener for each device in the list
          for (var deviceId in deviceList) {
            if (deviceId != null) {
              // Actively listen to changes in each device
              _dbDev.child(deviceId).onValue.listen((DatabaseEvent deviceEvent) {
                if (deviceEvent.snapshot.value != null) {
                  var deviceData =
                      deviceEvent.snapshot.value as Map<dynamic, dynamic>;

                  // Extract device status and type
                  bool status = deviceData['status'] ?? false;
                  String type = deviceData['type'] ?? 'Unknown';

                  // Update device details incrementally
                  deviceDetails[deviceId] = {
                    'status': status,
                    'type': type,
                  };

                  // Notify UI with updated deviceDetails (incremental update)
                  userData['deviceDetails'] = deviceDetails;
                  onDataUpdated(
                      userData); // Update UI each time a device is fetched
                }
              }).onError((error) {
                print("Error listening to device $deviceId: $error");
              });
            }
          }
        } else {
          userData['deviceDetails'] = {};
          onDataUpdated(userData); // No devices found, notify UI
        }
      } else {
        onDataUpdated({}); // No user data found, notify UI
      }
    });
  }

  // Function to update the status of a specific device
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
