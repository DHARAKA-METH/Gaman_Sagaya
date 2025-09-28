import 'package:bus_tracker_app/src/repositories/other_function.dart';
import 'package:bus_tracker_app/src/services/firestore_service.dart';

Future<void> mainFunction() async {
  String from = "kottawa";
  String destination = "maharagama";
  String apiKey = "YOUR_GOOGLE_API_KEY";

  // Fetch all routes (async)
  List<Map<String, dynamic>> allRoutes = await fetchAllRoutes(
    from,
    destination,
  );

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
    6.1036, // Example user latitude
    80.3171, // Example user longitude
  );

  if (allRoutes.isNotEmpty) {
    //  print('Route ID: ${allRoutes}');
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
