import 'package:flutter/material.dart';

class MallParkingPage extends StatelessWidget {
  const MallParkingPage({super.key}); // ✅

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mall Parking")),
      body: const Center(child: Text("Halaman Mall Parking")),
    );
  }
}
