import 'package:flutter/material.dart';

class RoadParkPage extends StatelessWidget {
  const RoadParkPage({super.key}); // ✅

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Road Park")),
      body: const Center(child: Text("Halaman Road Park")),
    );
  }
}
