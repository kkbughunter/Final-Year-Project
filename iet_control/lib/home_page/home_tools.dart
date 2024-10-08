import 'package:flutter/material.dart';

class HomeTools {
  static Widget buildSquareDeviceCard({
    required bool isOn,
    required ValueChanged<bool> onChange,
    required String title,
  }) {
    return Container(
      height: 100,
      width: 100,
      child: Card(
        color: isOn ? Colors.yellow[200] : Colors.grey[300],
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large Light icon in the center

              // const Spacer(),

              // Title text
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // const Spacer(),
              SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.lightbulb,
                  color: isOn ? Colors.amber : Colors.grey,
                  size: 50, // Larger icon size
                ),
              ),
              // Toggle switch
              Switch(
                value: isOn,
                onChanged: onChange,
                activeColor: Colors.red,
                inactiveThumbColor: Colors.grey,
              ),

              const SizedBox(height: 10),

              // More button at the bottom
              TextButton(
                onPressed: () {
                  print("More clicked");
                },
                child: Text(
                  "More",
                  style: TextStyle(color: isOn ? Colors.blue : Colors.grey),
                ),
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
    // required String subtitle,
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
