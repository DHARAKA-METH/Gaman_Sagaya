import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> GetBusesETA(
  // Google Distance Matrix API
  String apiKey,
  double originLat,
  double originLng,
  double destLat,
  double destLng,
) async {
  print(
    "origins -${originLat} - ${originLng}  ----  desti ${destLat} , ${destLng}",
  );

  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/distancematrix/json'
    '?origins=$originLat,$originLng'
    '&destinations=$destLat,$destLng'
    '&mode=driving'
    '&key=$apiKey',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final element = data['rows'][0]['elements'][0];

        if (element['status'] == 'OK' &&
            element['distance'] != null &&
            element['duration'] != null) {
          return {
            'distance': element['distance']['text'],
            'duration': element['duration']['text'],
            'seconds': element['duration']['value'],
          };
        }
      } else {
        print("Google API Error: ${data['status']}");
      }
    } else {
      print("HTTP Error: ${response.statusCode}");
    }
  } catch (e) {
    print('HTTP Exception: $e');
  }

  return null;
}
