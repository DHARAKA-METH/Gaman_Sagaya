import 'package:bus_tracker_app/src/repositories/other_function.dart';
import 'package:bus_tracker_app/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> mainFunction() async {
  String from = "kottawa";
  String destination = "maharagama";
  String apiKey = "YOUR_GOOGLE_API_KEY";
  //String apiKey = "AIzaSyCRmgwCb_A9tft0SfuP_InGJ_9a8nAD0_Q";

  // Fetch all routes (async)
  List<Map<String, dynamic>> allRoutes = await fetchAllRoutes(
    from,
    destination,
  );

  // get cordinate for user From location by searching array or call google api

  GeoPoint? userCoords = getCoordinatesByStopName(from, allRoutes);
  if (userCoords == null) {
    throw Exception("User location coordinates not found!");
  }

  // Find routes with user destination
  List<Map<String, dynamic>> destinationwithid = findRoutesWithUserDestination(
    allRoutes,
    from,
    destination,
  );

  // Fetch buses based on the filtered routes
  List<Map<String, dynamic>> getBusses = await fetchBusses(destinationwithid);

  // Ca;culatye ETA for each bus
  List<Map<String, dynamic>> etaResults = await calculateETAS(
    apiKey,
    getBusses,
    userCoords.latitude,
    userCoords.longitude,
  );

  if (allRoutes.isNotEmpty) {
    //print('Route ID: ${allRoutes}');
    // print('user cords : ${userCoords.latitude} - ${userCoords.longitude}');
    print('');
    print('');
    print('-------------- destinationwithid -----------');
    print(destinationwithid);
    print('----------  getBusses---------------');
    print(getBusses);
    print('------------  etaResults-------------');
    print(etaResults);
  } else {
    print('No matching routes found.');
  }
}
