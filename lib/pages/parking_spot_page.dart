import 'package:flutter/material.dart';

class ParkingSpotPage extends StatelessWidget {
  const ParkingSpotPage({super.key}); // ✅

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parking Spot")),
      body: const Center(child: Text("Halaman Parking Spot")),
    );
  }
}
