import 'package:flutter/material.dart';
import 'home_page_service.dart';
import 'home_page_repo.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> switchStates = [];
  Map<dynamic, dynamic> fetchedData =
      {}; // Store the fetched user and device data
  final HomePageRepo _homePageRepo =
      HomePageRepo(); // Create an instance of HomePageRepo

  @override
  void initState() {
    super.initState();
    // Fetch user data and listen for real-time updates
    _homePageRepo.fetchUserData(widget.userId, (data) {
      print("Data received from Firebase: $data");

      if (data.isNotEmpty && data.containsKey('deviceDetails')) {
        setState(() {
          fetchedData = data;

          // Filter out null values from devices
          fetchedData['deviceDetails'] =
              Map<String, Map<dynamic, dynamic>>.from(
            fetchedData['deviceDetails'].cast<String, Map<dynamic, dynamic>>(),
          );
          fetchedData['deviceDetails']
              .removeWhere((key, value) => value == null);

          if (fetchedData['deviceDetails'].isNotEmpty) {
            switchStates = List<bool>.generate(
              fetchedData['deviceDetails'].length,
              (index) {
                var device =
                    fetchedData['deviceDetails'].values.elementAt(index);
                return device['status'] == true; // Check status
              },
            );
          } else {
            switchStates.clear();
          }
          print(switchStates);
        });
      } else {
        setState(() {
          fetchedData['deviceDetails'] = {};
          switchStates.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomePageService(
      fetchedData: fetchedData,
      switchStates: switchStates,
      onSwitchToggle: (index, newValue) {
        setState(() {
          switchStates[index] = newValue;
          String key = fetchedData['deviceDetails'].keys.elementAt(index);
          print("Key" + key);
          _homePageRepo.updateStatus(key, newValue); // Update the status
        });
      },
    );
  }
}
