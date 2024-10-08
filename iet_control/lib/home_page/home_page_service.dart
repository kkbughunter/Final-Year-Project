import 'package:flutter/material.dart';
import 'package:iet_control/home_page/home_tools.dart';

class HomePageService extends StatelessWidget {
  final Map<dynamic, dynamic> fetchedData;
  final List<bool> switchStates;
  final Function(int index, bool newValue) onSwitchToggle;

  const HomePageService({
    Key? key,
    required this.fetchedData,
    required this.switchStates,
    required this.onSwitchToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: fetchedData.isEmpty || fetchedData['deviceDetails'] == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading state initially
          : fetchedData['deviceDetails'].isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/no_devices_1.jpg',
                          width: 200, height: 200), // Replace with your image
                      const SizedBox(height: 20),
                      const Text(
                        ":( \nSORRY! \nNo devices available ",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ) // Show "No devices available" when empty
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: fetchedData['deviceDetails'].length,
                  itemBuilder: (context, index) {
                    String key =
                        fetchedData['deviceDetails'].keys.elementAt(index);
                    String name = fetchedData['deviceDetails'][key]?['name'] ??
                        'Unknown Device';
                    String type = fetchedData['deviceDetails'][key]?['type'] ??
                        'Unknown Device';
                    bool isOn = switchStates[index];

                    if (type == "light") { // type = light
                      return HomeTools.buildSquareDeviceCard(
                        title: name,
                        type: type, // added
                        isOn: isOn,
                        onChange: (newValue) => onSwitchToggle(index, newValue),
                      );
                    } else { // type = fan   --> Problem in Displaying 
                      // return HomeTools.buildRectangularDeviceCard(
                      //   title: "Living Room Light", // Title text for the card
                      //   subtitle: "Smart Light", // Subtitle text for the card
                      //   currentValue: 5, // Initial slider value
                      //   onChange: (newValue) {
                      //     // Callback when slider value changes
                      //     print("New Value: $newValue");
                      //     // Handle your logic here
                      //   },
                      // );
                    }
                  },
                ),
    );
  }
}
