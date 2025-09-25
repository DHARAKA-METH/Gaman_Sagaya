import 'package:bus_tracker_app/src/repositories/other_function.dart';
import 'package:bus_tracker_app/src/services/firestore_service.dart';

Future<void> mainFunction() async {
  String from = "kottawa";
  String destination = "pettah";

  // Fetch all routes (async)
  List<Map<String, dynamic>> allRoutes = await fetchAllRoutes(
    from,
    destination,
  );
  List<Map<String, dynamic>> destinationwithid = findRoutesWithUserDestination(
    allRoutes,
    from,
    destination,
  );

  if (allRoutes.isNotEmpty) {
    //  print('Route ID: ${allRoutes}');
    print(destinationwithid);
    print('-------------------------');
  } else {
    print('No matching routes found.');
  }
}
