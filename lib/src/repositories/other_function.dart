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
