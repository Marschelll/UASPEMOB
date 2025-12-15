import 'package:flutter/material.dart';

class MyVehiclePage extends StatefulWidget {
  const MyVehiclePage({super.key});

  @override
  State<MyVehiclePage> createState() => _MyVehiclePageState();
}

class _MyVehiclePageState extends State<MyVehiclePage> {
  // ================= DATA KENDARAAN =================
  final List<Map<String, dynamic>> vehicles = [
    {
      "name": "Honda Beat",
      "plate": "B 1234 ABC",
      "icon": Icons.motorcycle,
    },
    {
      "name": "Toyota Avanza",
      "plate": "D 5678 XYZ",
      "icon": Icons.directions_car,
    },
  ];

  // ================= CONTROLLER =================
  final TextEditingController nameController = TextEditingController();
  final TextEditingController plateController = TextEditingController();

  IconData selectedIcon = Icons.directions_car;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ================= APP BAR =================
      appBar: AppBar(
        title: const Text("Kendaraan Saya"),
        backgroundColor: Colors.blue,
      ),

      // ================= BODY =================
      body: vehicles.isEmpty
          ? const Center(child: Text("Belum ada kendaraan"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return vehicleCard(
            index,
            vehicle["name"],
            vehicle["plate"],
            vehicle["icon"],
          );
        },
      ),

      // ================= ADD VEHICLE =================
      floatingActionButton: FloatingActionButton(
        onPressed: showAddVehicleDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ================= VEHICLE CARD =================
  Widget vehicleCard(int index, String name, String plate, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
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

          // ---------- DELETE ----------
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                vehicles.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  // ================= ADD VEHICLE DIALOG =================
  void showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
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

              // ---------- ICON SELECT ----------
              DropdownButton<IconData>(
                value: selectedIcon,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: Icons.directions_car,
                    child: Text("Mobil"),
                  ),
                  DropdownMenuItem(
                    value: Icons.motorcycle,
                    child: Text("Motor"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedIcon = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    plateController.text.isEmpty) return;

                setState(() {
                  vehicles.add({
                    "name": nameController.text,
                    "plate": plateController.text,
                    "icon": selectedIcon,
                  });
                });

                nameController.clear();
                plateController.clear();
                selectedIcon = Icons.directions_car;

                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}
