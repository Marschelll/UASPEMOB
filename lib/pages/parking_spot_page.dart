import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ParkingSpotPage extends StatefulWidget {
  const ParkingSpotPage({super.key});

  @override
  State<ParkingSpotPage> createState() => _ParkingSpotPageState();
}

class _ParkingSpotPageState extends State<ParkingSpotPage> {
  LatLng? userLocation;
  LatLng? nearestParking;
  List<LatLng> routePoints = [];

  double distanceToParking = 0; // meter
  double estimatedTime = 0; // menit

  StreamSubscription<Position>? positionStream;
  final Distance distanceCalc = const Distance();

  // 📍 DATA PARKIR MEDAN
  final List<LatLng> parkingSpots = [
    LatLng(3.5952, 98.6722), // Sun Plaza
    LatLng(3.5878, 98.6765), // Medan Mall
    LatLng(3.5897, 98.6738), // Lapangan Merdeka
  ];

  LatLng? lastRouteLocation;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  // ======================
  // GPS REAL-TIME
  // ======================
  void _startTracking() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // update tiap 10 meter
      ),
    ).listen((Position pos) {
      userLocation = LatLng(pos.latitude, pos.longitude);
      _findNearestParking();
      _updateDistance();

      // 🔥 optimasi: update rute hanya jika >20 meter
      if (lastRouteLocation == null ||
          distanceCalc(lastRouteLocation!, userLocation!) > 20) {
        _fetchRoute();
        lastRouteLocation = userLocation;
      }

      setState(() {});
    });
  }

  // ======================
  // PARKIR TERDEKAT
  // ======================
  void _findNearestParking() {
    double min = double.infinity;
    for (var p in parkingSpots) {
      final d = distanceCalc(userLocation!, p);
      if (d < min) {
        min = d;
        nearestParking = p;
      }
    }
  }

  // ======================
  // JARAK USER → PARKIR
  // ======================
  void _updateDistance() {
    if (nearestParking != null) {
      distanceToParking =
          distanceCalc(userLocation!, nearestParking!);
    }
  }

  // ======================
  // ROUTING OSRM + ETA
  // ======================
  Future<void> _fetchRoute() async {
    if (nearestParking == null) return;

    final url =
        "https://router.project-osrm.org/route/v1/driving/"
        "${userLocation!.longitude},${userLocation!.latitude};"
        "${nearestParking!.longitude},${nearestParking!.latitude}"
        "?overview=full&geometries=geojson";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final route = data['routes'][0];

      final coords = route['geometry']['coordinates'];
      final duration = route['duration']; // detik

      routePoints =
          coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();

      estimatedTime = duration / 60; // menit
    }
  }

  // ======================
  // UI
  // ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Navigasi Parkir Medan")),
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: userLocation!,
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName:
                'com.example.uaspememob2',
              ),

              MarkerLayer(
                markers: [
                  // USER
                  Marker(
                    point: userLocation!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),

                  // PARKIR
                  ...parkingSpots.map(
                        (p) => Marker(
                      point: p,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.local_parking,
                        color: Colors.green,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),

              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 5,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),

          // ======================
          // INFO PANEL
          // ======================
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Parkir Terdekat",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Jarak: ${(distanceToParking / 1000).toStringAsFixed(2)} km",
                    ),
                    Text(
                      "Estimasi Waktu: ${estimatedTime.toStringAsFixed(1)} menit",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}