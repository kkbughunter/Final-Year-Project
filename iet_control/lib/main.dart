import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iet_control/app_theme/app_dart_theme.dart';
import 'package:iet_control/firebase_options.dart';
import 'package:iet_control/home_page/home_page_repo.dart';
import 'home_page/home_page.dart';


void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
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
      home: const HomePage(userId: "9JXfAUKqX0SWDt0zUgQYxDRWneM2"),
      // home: const MyHomePage(),
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
