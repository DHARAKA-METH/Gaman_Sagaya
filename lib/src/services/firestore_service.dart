import 'package:bus_tracker_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<List<Map<String, dynamic>>> fetchAllRoutes(
  String from,
  String destination,
) async {
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  List<Map<String, dynamic>> matchingRoutes = [];

  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('routes')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Check if stops exist
      if (data['stops'] != null && data['stops'] is List) {
        final stops = data['stops'] as List;

        // Convert all stop names to lowercase
        final stopNames = stops
            .map((stop) => (stop['name'] ?? '').toString().trim().toLowerCase())
            .toList();

        // Check if both 'from' and 'destination' exist in stops
        if (stopNames.contains(from.toLowerCase()) &&
            stopNames.contains(destination.toLowerCase())) {
          // Add entire route to matchingRoutes
          matchingRoutes.add(data);
        }
      }
    }

    return matchingRoutes;
  } catch (e) {
    print('Error fetching routes: $e');
  }

  return matchingRoutes;
}
