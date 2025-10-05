import 'package:bus_tracker_app/src/repositories/main_repository.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracker_app/src/ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase

  // Fetch and print all routes from Firestore
  mainFunction();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bus Tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BusHomeScreen(),
    );
  }
}
