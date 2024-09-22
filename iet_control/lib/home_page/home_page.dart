import 'package:flutter/material.dart';
import 'package:iet_control/home_page/home_page_repo.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> switchStates = [];
  Map<dynamic, dynamic> fetchedData = {}; // Store fetched user and device data

  final HomePageRepo _homePageRepo =
      HomePageRepo(); // Create an instance of HomePageRepo

  @override
  void initState() {
    super.initState();

    // Fetch user data and listen for updates
    _homePageRepo.fetchUserData(widget.userId, (data) {
      if (data.containsKey('deviceDetails')) {
        setState(() {
          fetchedData = data;

          // Initialize switch states based on device status (boolean)
          switchStates = List<bool>.generate(
            fetchedData['deviceDetails'].length,
            (index) =>
                fetchedData['deviceDetails']
                    .values
                    .elementAt(index)['status'] ==
                true,
          );
        });
      } else {
        print("No 'deviceDetails' found in the data.");
      }
    });
  }

  // Function to build each card
  Widget buildCard({
    required bool isOn,
    required ValueChanged<bool> onChange,
    required String title,
  }) {
    return Container(
      height: 215,
      width: 150,
      child: Card(
        color: isOn ? const Color.fromARGB(224, 223, 202, 21) : Colors.grey,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(title),
            SizedBox(height: 10),
            Switch(
              value: isOn,
              onChanged: onChange,
              activeColor: Colors.yellow[600],
              activeTrackColor: Colors.yellow[300],
              inactiveThumbColor: Colors.grey[600],
              inactiveTrackColor: Colors.grey[300],
            ),
            Text(
              isOn ? "ON" : "OFF",
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                print("Clicked More!");
              },
              child: Text("More"),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("IET control"),
        actions: [
          IconButton(
              onPressed: () {
                print("Clicked add");
              },
              icon: Icon(Icons.add))
        ],
      ),
      backgroundColor: Colors.white,
      body: fetchedData.isEmpty || !fetchedData.containsKey('deviceDetails')
          ? Center(
              child:
                  CircularProgressIndicator(), // Show loading spinner while data is being fetched
            )
          : GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards per row
                crossAxisSpacing: 10, // Spacing between columns
                mainAxisSpacing: 10, // Spacing between rows
                childAspectRatio:
                    0.7, // Aspect ratio of the cards (height/width)
              ),
              itemCount: fetchedData['deviceDetails']
                  .length, // Number of cards based on fetched device data
              itemBuilder: (context, index) {
                String key = fetchedData['deviceDetails'].keys.elementAt(index);
                String type = fetchedData['deviceDetails'][key]['type'];
                bool isOn = switchStates[index]; // Get the status of the switch

                return buildCard(
                  title: type, // Pass the switch name/type
                  isOn: isOn, // Pass the switch status
                  onChange: (newValue) {
                    setState(() {
                      switchStates[index] =
                          newValue; // Update individual switch state
                      // Update the status in Firebase with a boolean value
                      _homePageRepo.updateStatus(key,
                          newValue); // Call instance method with boolean value
                    });
                  },
                );
              },
            ),
    );
  }
}
