import 'package:flutter/material.dart';
import 'dart:math';

class HomePageService extends StatelessWidget {
  final Map<dynamic, dynamic> fetchedData;
  final List<bool> switchStates;
  final Function(int index, bool newValue) onSwitchToggle;

  const HomePageService({
    super.key,
    required this.fetchedData,
    required this.switchStates,
    required this.onSwitchToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("IET Control"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_box_rounded,
              size: 40.0,
              color: Color.fromARGB(255, 232, 255, 83),
            ), // Add icon in AppBar
            onPressed: () {
              // Action when the icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDevicePage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: fetchedData.isEmpty || fetchedData['deviceDetails'] == null
          ? const Center(
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
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: fetchedData['deviceDetails'].length,
                  itemBuilder: (context, index) {
                    String key =
                        fetchedData['deviceDetails'].keys.elementAt(index);
                    String type = fetchedData['deviceDetails'][key]?['type'] ??
                        'Unknown Device';
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
    return SizedBox(
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
              const SizedBox(height: 10),
              Switch(
                value: isOn,
                onChanged: onChange,
                activeColor: Colors.yellow[600],
                activeTrackColor: Colors.yellow[300],
                inactiveThumbColor: Colors.grey[600],
                inactiveTrackColor: Colors.grey[300],
              ),
              Text(isOn ? "ON" : "OFF"),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  print("Clicked More!");
                },
                child: const Text("More"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class AddDevicePage extends StatefulWidget {
  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  // Available networks with their signal strengths
  List<Map<String, dynamic>> availableNetworks = [
    {'ssid': 'Home Network', 'signal': -100, 'security': 'WPA2'},
    {'ssid': 'Coffee Shop WiFi', 'signal': -70, 'security': 'Open'},
    {'ssid': 'Office Network', 'signal': -60, 'security': 'WPA3'},
    {'ssid': 'Public WiFi', 'signal': -80, 'security': 'Open'}
  ];

  // Method to simulate scanning for networks
  void scanForNetworks() {
    setState(() {
      // Simulate a network scan and update availableNetworks
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Device'),
        backgroundColor: const Color(0xFF1F3A93),
      ),
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background signal circles
                buildSignalCircle(radius: 150, color: Colors.red.shade100),
                buildSignalCircle(radius: 250, color: Colors.orange.shade100),
                buildSignalCircle(radius: 350, color: Colors.green.shade100),
                
                // Place devices on the circles based on signal strength
                ...availableNetworks.map((network) {
                  return Positioned(
                    left: getPosition(network['signal'], 350).dx,
                    top: getPosition(network['signal'], 350).dy,
                    child: buildDeviceIcon(network),
                  );
                }).toList(),
              ],
            ),
          ),
          // Device list with connection buttons
          Expanded(
            child: ListView.builder(
              itemCount: availableNetworks.length,
              itemBuilder: (context, index) {
                final network = availableNetworks[index];
                return ListTile(
                  leading: Icon(
                    Icons.wifi,
                    color: getSignalColor(network['signal']),
                  ),
                  title: Text(
                    network['ssid'],
                    style: TextStyle(color: const Color(0xFF4D4D4D)),
                  ),
                  subtitle: Text(
                    'Signal: ${network['signal']} dBm, Security: ${network['security']}',
                    style: TextStyle(color: const Color(0xFF4D4D4D)),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Connect action
                    },
                    child: const Text('Connect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF27AE60),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanForNetworks,
        child: Icon(Icons.refresh),
        backgroundColor: const Color(0xFF1F3A93),
        tooltip: 'Scan for Wi-Fi networks',
      ),
    );
  }

  // Helper function to determine the signal strength color
  Color getSignalColor(int signalStrength) {
    if (signalStrength >= -50) {
      return Colors.green;
    } else if (signalStrength >= -70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Widget to build each signal circle
  Widget buildSignalCircle({required double radius, required Color color}) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.3),
      ),
    );
  }

  // Function to get position based on signal strength
  Offset getPosition(int signalStrength, double maxRadius) {
    double angle = (signalStrength + 100) * pi / 50; // Convert signal to angle
    double distance = (100 + signalStrength) * (maxRadius / 100); // Distance based on signal

    double dx = maxRadius / 2 + cos(angle) * distance;
    double dy = maxRadius / 2 + sin(angle) * distance;
    return Offset(dx, dy);
  }

  // Widget to build device icon
  Widget buildDeviceIcon(Map<String, dynamic> network) {
    return Column(
      children: [
        Icon(
          Icons.wifi,
          size: 30,
          color: getSignalColor(network['signal']),
        ),
        Text(
          network['ssid'],
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}


