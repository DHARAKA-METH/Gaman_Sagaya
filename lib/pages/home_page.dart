import 'package:flutter/material.dart';

class BusApp extends StatelessWidget {
  const BusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bus Finder",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BusHomeScreen(),
    );
  }
}

class BusHomeScreen extends StatefulWidget {
  const BusHomeScreen({super.key});

  @override
  State<BusHomeScreen> createState() => _BusHomeScreenState();
}

class _BusHomeScreenState extends State<BusHomeScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  // Mock bus list (later you can connect with API)
  List<Map<String, String>> buses = [
    {"name": "Bus 101", "eta": "5 mins"},
    {"name": "Bus 205", "eta": "12 mins"},
    {"name": "Bus 310", "eta": "20 mins"},
  ];

  bool showBusList = false;

  void searchBuses() {
    setState(() {
      showBusList = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Google Maps style header
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    controller: fromController,
                    decoration: InputDecoration(
                      hintText: "From",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: toController,
                    decoration: InputDecoration(
                      hintText: "To",
                      prefixIcon: const Icon(Icons.flag_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: searchBuses,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Find Buses"),
                  ),
                ],
              ),
            ),

            // Bus List with ETA
            Expanded(
              child: showBusList
                  ? ListView.builder(
                      itemCount: buses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.directions_bus,
                                color: Colors.blue),
                            title: Text(buses[index]["name"]!),
                            subtitle: Text("ETA: ${buses[index]["eta"]}"),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "Enter From & To and press Find Buses",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
