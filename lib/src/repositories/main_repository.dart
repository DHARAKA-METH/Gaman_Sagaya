import 'package:bus_tracker_app/src/repositories/other_function.dart';
import 'package:bus_tracker_app/src/services/firestore_service.dart';

Future<void> mainFunction() async {
  String from = "kottawa";
  String destination = "maharagama";

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

  if (allRoutes.isNotEmpty) {
    //  print('Route ID: ${allRoutes}');
    print(destinationwithid);
    print('-------------------------');
    print(getBusses);
  } else {
    print('No matching routes found.');
  }
}
