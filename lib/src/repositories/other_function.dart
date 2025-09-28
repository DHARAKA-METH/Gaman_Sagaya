import 'package:bus_tracker_app/src/services/firestore_service.dart';
import 'package:bus_tracker_app/src/services/googleApi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<Map<String, dynamic>> findRoutesWithUserDestination(
  List allRoutes,
  String from,
  String destination,
) {
  from = from.toLowerCase();
  destination = destination.toLowerCase();

  List<Map<String, dynamic>> results = [];

  for (var route in allRoutes) {
    if (route['stops'] != null && route['stops'] is List) {
      List stops = route['stops'];

      // Convert stop names to lowercase
      List<String> stopNames = stops
          .map((stop) => (stop['name'] ?? '').toString().toLowerCase())
          .toList();

      int fromIndex = stopNames.indexOf(from);
      int destIndex = stopNames.indexOf(destination);

      if (fromIndex != -1 && destIndex != -1) {
        // Split into left and right arrays
        List leftArray = stops.sublist(0, fromIndex + 1); // Pettah → Kottawa
        List rightArray = stops.sublist(fromIndex); // Kottawa → Homagama

        String finalDestination = "";

        // Case 1: destination is in left side
        if (destIndex <= fromIndex) {
          finalDestination = leftArray.first['name']; // first element (Pettah)
        }
        // Case 2: destination is in right side
        else {
          finalDestination = rightArray.last['name']; // last element (Homagama)
        }

        results.add({
          "routeId": route['routeId'],
          "destination": finalDestination,
        });
      }
    }
  }

  return results;
}

Future<List<Map<String, dynamic>>> getBuses(
  List<Map<String, dynamic>> destinationWithId,
) async {
  try {
    // Call the function
    List<Map<String, dynamic>> buses = await fetchBusses(destinationWithId);
    return buses;
  } catch (e) {
    print("Error fetching buses: $e");
    throw e;
  }
}

Future<List<Map<String, dynamic>>> calculateETAS(
  String apiKey,
  List busArray,
  double userCurrentlatitude,
  double userCurrentlongitude,
) async {
  List<String> busIds = busArray.map((bus) => bus['busId'] as String).toList();
  List<Map<String, dynamic>> busEtaList = [];

  for (var busId in busIds) {
    // bus live location
    Map<String, dynamic>? busLocation = await getBusCurrentLocation(busId);

    //  get latitude & longitude of the bus
    double buslatitude = busLocation?[busId]!['latitude']!;
    double buslongitude = busLocation?[busId]!['longitude']!;

    /* here missed bus is miss or not to user current location     
https://chatgpt.com/c/68d4fc6c-220c-8323-84ef-31daca2b58f2 ------------------------------------------------------------------------------------- */
    /* ignore this for now */

    final EtaData = await GetBusesETA(
      apiKey,
      buslatitude,
      buslongitude,
      userCurrentlatitude,
      userCurrentlongitude,
    );
    if (EtaData != null) {
      busEtaList.add({"busId": busId, ...EtaData});
    } else {
      busEtaList.add({"distance": "N/A", "duration": "N/A", "seconds": 0});
    }
  }
  ;

  return busEtaList;
}
