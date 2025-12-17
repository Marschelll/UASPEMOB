import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyVehiclePage extends StatefulWidget {
  const MyVehiclePage({super.key});

  @override
  State<MyVehiclePage> createState() => _MyVehiclePageState();
}

class _MyVehiclePageState extends State<MyVehiclePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  String selectedType = 'car'; // car | motorcycle

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print("LOGIN UID: ${user?.uid}");

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Kendaraan Saya"),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text("Silakan login dulu"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Kendaraan Saya"),
        backgroundColor: Colors.blue,
      ),

      // ================= BODY =================
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('vehicles')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Terjadi kesalahan: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum ada kendaraan"),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return vehicleCard(
                vehicleId: docs[index].id,
                name: data['name'],
                plate: data['plate'],
                type: data['type'],
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddVehicleDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ================= VEHICLE CARD =================
  Widget vehicleCard({
    required String vehicleId,
    required String name,
    required String plate,
    required String type,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            type == 'car'
                ? Icons.directions_car
                : Icons.motorcycle,
            size: 40,
            color: Colors.blue,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(plate),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('vehicles')
                  .doc(vehicleId)
                  .delete();
            },
          ),
        ],
      ),
    );
  }

  // ================= ADD VEHICLE =================
  void showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Kendaraan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama Kendaraan",
              ),
            ),
            TextField(
              controller: plateController,
              decoration: const InputDecoration(
                labelText: "Plat Nomor",
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(value: 'car', child: Text("Mobil")),
                DropdownMenuItem(value: 'motorcycle', child: Text("Motor")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Jenis Kendaraan",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              print("ADD VEHICLE UID: ${user.uid}");

              // 🔑 PASTIKAN USER DOC ADA
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set({
                'email': user.email,
                'updatedAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));

              // ➕ TAMBAH VEHICLE
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('vehicles')
                  .add({
                'name': nameController.text.trim(),
                'plate': plateController.text.trim(),
                'type': selectedType,
                'createdAt': FieldValue.serverTimestamp(),
              });

              nameController.clear();
              plateController.clear();
              selectedType = 'car';

              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
