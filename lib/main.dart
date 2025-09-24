import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // created by flutterfire configure
import 'package:bus_tracker_app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Fetch and print all routes from Firestore
  fetchAllRoutes();

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

/// Function to fetch all routes from Firestore collection "routes"
void fetchAllRoutes() async {
  try {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('routes').get();

    print('--- All Routes in Firestore ---');
    for (var doc in snapshot.docs) {
      print('Route ID: ${doc.id}');
      print('Data: ${doc.data()}');
      print('-------------------------');
    }
  } catch (e) {
    print('Error fetching routes: $e');
  }
}
