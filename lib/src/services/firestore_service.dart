import 'package:bus_tracker_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<List<Map<String, dynamic>>> fetchAllRoutes(
  String from,
  String destination,
) async {
  List<Map<String, dynamic>> matchingRoutes = [];

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Fetch all routes
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
        if (stopNames.contains(from.toLowerCase().trim()) &&
            stopNames.contains(destination.toLowerCase().trim())) {
          // Add entire route to matchingRoutes
          matchingRoutes.add(data);
        }
      }
    }
  } catch (e) {
    print(' Error fetching routes: $e');
  }

  return matchingRoutes;
}

Future<List<Map<String, dynamic>>> fetchBusses(
  List<Map<String, dynamic>> destinationWithId,
) async {
  List<Map<String, dynamic>> matchingBuses = [];

  try {
    // Fetch all buses
    QuerySnapshot busSnapshot = await FirebaseFirestore.instance
        .collection('buses')
        .get();

    List<Map<String, dynamic>> allBuses = busSnapshot.docs
        .map((doc) => {...doc.data() as Map<String, dynamic>, "id": doc.id})
        .toList();

    for (var filterItem in destinationWithId) {
      String routeIdFilter = filterItem['routeId']
          .toString()
          .trim()
          .toLowerCase();
      String destinationFilter = filterItem['destination']
          .toString()
          .trim()
          .toLowerCase();

      // Filter buses
      List<Map<String, dynamic>> filtered = allBuses.where((bus) {
        String busRouteId = bus['routeId'].toString().trim().toLowerCase();
        String busDestination = bus['currentDestination']
            .toString()
            .trim()
            .toLowerCase();
        String busStatus = bus['status'].toString().trim().toLowerCase();

        return busStatus == 'online' &&
            busRouteId == routeIdFilter &&
            busDestination == destinationFilter;
      }).toList();

      matchingBuses.addAll(filtered);
    }
  } catch (e) {
    print(" Error fetching buses: $e");
  }

  return matchingBuses;
}

Future<Map<String, dynamic>?> getBusCurrentLocation(String busId) async {
  try {
    // Reference to the bus in Realtime Database
    final dbRef = FirebaseDatabase.instance.ref('BusLiveLocations/$busId');

    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      // Convert keys to String and return
      return data.map((key, value) => MapEntry(key.toString(), value));
    } else {
      print('No live location found for busId $busId');
      return null;
    }
  } catch (e) {
    print('Error fetching live location: $e');
    return null;
  }
}
