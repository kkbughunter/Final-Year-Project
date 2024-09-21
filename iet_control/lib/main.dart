import 'package:flutter/material.dart';
import 'package:iet_control/app_theme/app_dart_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppDarkTheme.darkTheme, // Apply light theme here
      darkTheme: AppDarkTheme.darkTheme, // Optionally add a dark theme
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("IET Control"),
      ),
      body: const Center(
        child: Text("IET Control"),
      ),
    );
  }
}
