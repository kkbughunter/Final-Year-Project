import 'package:flutter/material.dart';
import 'dart:math';
import 'package:wifi_scan/wifi_scan.dart';
import 'dart:async';
import 'package:wifi_iot/wifi_iot.dart';

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
  List<WiFiAccessPoint> availableNetworks = [];
  Timer? scanTimer;

  @override
  void initState() {
    super.initState();
    startRealTimeScanning(); // Start periodic scanning
  }

  @override
  void dispose() {
    stopRealTimeScanning(); // Stop scanning when the widget is disposed
    super.dispose();
  }

  // Function to start periodic scanning
  void startRealTimeScanning() {
    scanForNetworks();
    scanTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      scanForNetworks();
    });
  }

  // Function to stop the timer
  void stopRealTimeScanning() {
    if (scanTimer != null) {
      scanTimer!.cancel();
    }
  }

  // Function to scan for networks and update the list
  void scanForNetworks() async {
    await WiFiScan.instance.startScan();
    final List<WiFiAccessPoint>? networks = await WiFiScan.instance.getScannedResults();

    setState(() {
      availableNetworks = networks?.where((network) => network.ssid.startsWith('IET')).toList() ?? [];
      if (availableNetworks.isNotEmpty) {
        for (var network in availableNetworks) {
          print(
              'Network detected: ${network.ssid}, Signal Strength: ${network.level} dBm');
        }
      } else {
        print('No networks detected');
      }
    });
  }

  // Function to show the dialog asking for the Wi-Fi password
  void showPasswordDialog(WiFiAccessPoint network) {
    String password = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter password for ${network.ssid}"),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            decoration: const InputDecoration(
              hintText: "Password",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                connectToWiFi(
                    network.ssid, password); // Connect using the password
              },
              child: const Text("Connect"),
            ),
          ],
        );
      },
    );
  }

  void connectToWiFi(String ssid, String password) async {
    try {
      print('Attempting to connect to network: $ssid');

      // Check if Wi-Fi is enabled
      var wifiEnabled =
          await WiFiForIoTPlugin.isEnabled(); // Check if Wi-Fi is enabled
      if (!wifiEnabled) {
        print('Wi-Fi is disabled');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Wi-Fi is disabled. Please enable it to connect.")),
        );
        return;
      }

      // Try connecting to the Wi-Fi network
      bool success = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security:
            NetworkSecurity.WPA, // Use WPA or adjust security type accordingly
        joinOnce: true, // Only join once without saving it to the device
      );

      if (success) {
        print('Successfully connected to $ssid');
      } else {
        print('Failed to connect to $ssid');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to connect to $ssid")),
        );
      }
    } catch (e) {
      print('Error while trying to connect: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
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
                buildSignalCircle(radius: 150, color: Colors.red.shade100),
                buildSignalCircle(radius: 250, color: Colors.orange.shade100),
                buildSignalCircle(radius: 350, color: Colors.green.shade100),
                ...availableNetworks.map((network) {
                  return Positioned(
                    left: getPosition(network.level ?? -100, 350).dx,
                    top: getPosition(network.level ?? -100, 350).dy,
                    child: buildDeviceIcon(network),
                  );
                }).toList(),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableNetworks.length,
              itemBuilder: (context, index) {
                final network = availableNetworks[index];
                return ListTile(
                  leading: Icon(
                    Icons.wifi,
                    color: getSignalColor(network.level ?? -100),
                  ),
                  title: Text(
                    network.ssid,
                    style: TextStyle(color: const Color(0xFF4D4D4D)),
                  ),
                  subtitle: Text(
                    'Signal: ${network.level} dBm',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      showPasswordDialog(
                          network); // Show the password dialog when "Connect" is pressed
                    },
                    child: const Text('Connect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF27AE60),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
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
    double angle = (signalStrength + 100) * pi / 50;
    double distance = (100 + signalStrength) * (maxRadius / 100);
    double dx = maxRadius / 2 + cos(angle) * distance;
    double dy = maxRadius / 2 + sin(angle) * distance;
    return Offset(dx, dy);
  }

  // Widget to build device icon
  Widget buildDeviceIcon(WiFiAccessPoint network) {
    return Column(
      children: [
        Icon(
          Icons.wifi,
          size: 30,
          color: getSignalColor(network.level),
        ),
        Text(
          network.ssid,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
