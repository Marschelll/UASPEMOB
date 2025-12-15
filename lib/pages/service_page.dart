import 'package:flutter/material.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key}); // ✅ TAMBAHKAN INI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service")),
      body: const Center(child: Text("Halaman Service")),
    );
  }
}
