import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("IET Control"),
      ),
      backgroundColor: Colors.white,
      body: fetchedData.isEmpty || fetchedData['deviceDetails'] == null
          ? Center(child: CircularProgressIndicator()) // Show loading state initially
          : fetchedData['deviceDetails'].isEmpty
              ? Center (child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/no_devices_1.jpg', width: 200, height: 200), // Replace with your image
                      SizedBox(height: 20),
                      Text(
                        ":( \nSORRY! \nNo devices available ",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )// Show "No devices available" when empty
              : GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: fetchedData['deviceDetails'].length,
                  itemBuilder: (context, index) {
                    String key = fetchedData['deviceDetails'].keys.elementAt(index);
                    String type = fetchedData['deviceDetails'][key]?['type'] ?? 'Unknown Device';
                    bool isOn = switchStates[index];

                    return buildCard(
                      title: type,
                      isOn: isOn,
                      onChange: (newValue) => onSwitchToggle(index, newValue),
                    );
                  },
                ),
    );
  }

  // Function to build each card for a device
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              Text(isOn ? "ON" : "OFF"),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  print("Clicked More!");
                },
                child: Text("More"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
