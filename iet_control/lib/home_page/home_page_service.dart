import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iet_control/home_page/home_tools.dart';

class HomePageService extends StatefulWidget {
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
  _HomePageServiceState createState() => _HomePageServiceState();
}

class _HomePageServiceState extends State<HomePageService> {
  bool _showNoDevicesMessage = false;

  @override
  void initState() {
    super.initState();
    // Wait for 1 second before showing the "No devices available" image and text.
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _showNoDevicesMessage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/149/149071.png',
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Action when the add button is pressed
            },
          ),
        ],
      ),
      body: widget.fetchedData.isEmpty ||
              widget.fetchedData['deviceDetails'] == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : widget.fetchedData['deviceDetails'].isEmpty
              ? Center(
                  child: _showNoDevicesMessage
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no_devices_1.jpg',
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              ":( \nSORRY! \nNo devices available ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Container(),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: widget.fetchedData['deviceDetails'].length,
                  itemBuilder: (context, index) {
                    String key = widget.fetchedData['deviceDetails'].keys
                        .elementAt(index);
                    String name = widget.fetchedData['deviceDetails'][key]
                            ?['name'] ??
                        'Unknown Device';
                    String type = widget.fetchedData['deviceDetails'][key]
                            ?['type'] ??
                        'Unknown Device';
                    bool isOn = widget.switchStates[index];

                    if (type == "light") {
                      return HomeTools.buildSquareDeviceCard(
                        title: name,
                        type: type,
                        isOn: isOn,
                        onChange: (newValue) =>
                            widget.onSwitchToggle(index, newValue),
                      );
                    } else {
                      // type = fan (for range option)
                    }
                    return null;
                  },
                ),
    );
  }
}
