import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false, // ⬅️ HILANGKAN ARROW BACK
        title: const Text(
          "Pengaturan",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================
      body: Column(
        children: [
          settingsItem("Ganti Password"),
          settingsItem("Email"),
          settingsItem("Keamanan"),
          settingsItem("Bahasa"),
          settingsItem("Pusat Bantuan"),
        ],
      ),
    );
  }

  // ================= SETTINGS ITEM =================
  Widget settingsItem(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.red,
          ),
          onTap: () {
            // nanti isi navigasi
          },
        ),
        const Divider(height: 1),
      ],
    );
  }
}