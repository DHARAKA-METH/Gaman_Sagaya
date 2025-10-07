import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  // Starting and destination points
  final LatLng _origin = const LatLng(6.9368, 79.8525); // Kottawa
  final LatLng _destination = const LatLng(6.8416, 79.9671); // Colombo

  final String googleApiKey = "AIzaSyCRmgwCb_A9tft0SfuP_InGJ_9a8nAD0_Q";

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> routePoints = []; // stores polyline route points

  int currentIndex = 0;
  Timer? _busTimer;

  @override
  void initState() {
    super.initState();

    // Add initial markers
    _markers.addAll([
      Marker(
        markerId: const MarkerId('origin'),
        position: _origin,
        infoWindow: const InfoWindow(title: 'Bus Start'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    ]);

    // Fetch and draw route only once
    _createPolylines();
  }

  @override
  void dispose() {
    _busTimer?.cancel();
    super.dispose();
  }

  /// Fetch and draw the route once from Directions API
  Future<void> _createPolylines() async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(_origin.latitude, _origin.longitude),
          destination: PointLatLng(
            _destination.latitude,
            _destination.longitude,
          ),
          mode: TravelMode.transit,
        ),
      );

      if (result.points.isNotEmpty) {
        routePoints = result.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId("busRoute"),
              color: Colors.blue,
              width: 5,
              points: routePoints,
            ),
          );
        });

        // Start moving bus marker along polyline
        _startBusSimulation();
      } else {
        print("⚠️ No points returned from polyline API.");
      }
    } catch (e) {
      print("❌ Error fetching polyline: $e");
    }
  }

  /// Move the bus marker along the polyline every few seconds
  void _startBusSimulation() {
    _busTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentIndex < routePoints.length) {
        LatLng nextPosition = routePoints[currentIndex];
        _updateBusMarker(nextPosition);
        currentIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  /// Update marker on the map
  void _updateBusMarker(LatLng newPosition) {
    setState(() {
      _markers.removeWhere((m) => m.markerId.value == 'origin');
      _markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: newPosition,
          infoWindow: const InfoWindow(title: 'Bus Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    });

    // Move camera to follow the bus
    mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Fit map around both origin and destination
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        _origin.latitude < _destination.latitude
            ? _origin.latitude
            : _destination.latitude,
        _origin.longitude < _destination.longitude
            ? _origin.longitude
            : _destination.longitude,
      ),
      northeast: LatLng(
        _origin.latitude > _destination.latitude
            ? _origin.latitude
            : _destination.latitude,
        _origin.longitude > _destination.longitude
            ? _origin.longitude
            : _destination.longitude,
      ),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Tracker (Optimized Route)")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _origin, zoom: 10),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}
