import 'package:flutter/material.dart';

class HomeTools {
  static Widget buildSquareDeviceCard({
    required bool isOn,
    required ValueChanged<bool> onChange,
    required String title,
    required String type,
  }) {
    return Container(
      // height: 50, // Adjusted for a more spacious layout
      // width: 40, // Slightly wider for accommodating elements
      child: Card(
        color: isOn ? Colors.yellow[200] : Colors.grey[300],
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align elements to the left
            children: [
              // Top Row (Light Icon and Wifi Icon)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.light,
                    size: 24,
                    color: isOn ? Colors.amber : Colors.grey,
                  ),
                  Icon(
                    Icons.wifi,
                    size: 24,
                    color: isOn ? Colors.blue : Colors.grey,
                  ),
                ],
              ),

              // const SizedBox(height: 12),
              Spacer(),

              // Title text (Name)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              // Subtitle text (Type)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  type,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),

              Spacer(), // Pushes the bottom part down

              // Bottom Row (Status Text and Toggle Switch)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status Text
                  Text(
                    isOn ? "On" : "Off",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isOn ? Colors.green : Colors.red,
                    ),
                  ),

                  // Toggle switch
                  Switch(
                    value: isOn,
                    onChanged: onChange,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildRectangularDeviceCard({
    required double currentValue,
    required ValueChanged<double> onChange,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 130,
      width: 250,
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "subtitle",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Slider(
                value: currentValue,
                onChanged: onChange,
                min: 0,
                max: 100,
                activeColor: Colors.orange,
                inactiveColor: Colors.grey[300],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("0:00"),
                  Text("5:25"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
