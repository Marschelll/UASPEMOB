import 'package:flutter/material.dart';
import '../widgets/profile_avatar.dart';
import 'my_vehicle_page.dart';
import 'favorite_page.dart';
import 'first_page.dart';
import 'address_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profil Saya",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 25),

          // ================= HEADER =================
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const ProfileAvatar(size: 90),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            "Jordi Sibero",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Bandung, Jawa Barat",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 30),

          // ================= MENU =================
          profileItem(
            context,
            Icons.directions_car,
            "Kendaraan Saya",
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyVehiclePage()),
            ),
          ),

          profileItem(
            context,
            Icons.location_on,
            "Alamat",
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddressPage()),
            ),
          ),


          profileItem(
            context,
            Icons.star,
            "Favorite",
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritePage()),
            ),
          ),

          profileItem(
            context,
            Icons.email,
            "Email",
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyVehiclePage()),
            ),
          ),

          const Spacer(),

          // ================= SWITCH ACCOUNT =================
          TextButton(
            onPressed: () => _showSwitchAccount(context),
            child: const Text(
              "Beralih Akun",
              style: TextStyle(color: Colors.red),
            ),
          ),

          const SizedBox(height: 8),

          // ================= LOGOUT =================
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => FirstPage()),
                    (route) => false,
              );
            },
            child: const Text(
              "Keluar",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= MENU ITEM =================
  Widget profileItem(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // ================= BOTTOM SHEET =================
  void _showSwitchAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Beralih Akun",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              ListTile(
                leading: const ProfileAvatar(size: 36),
                title: const Text("Jordi Sibero"),
                subtitle: const Text("Akun Aktif"),
                trailing: const Icon(Icons.check, color: Colors.green),
                onTap: () => Navigator.pop(context),
              ),

              ListTile(
                leading: const ProfileAvatar(size: 36),
                title: const Text("Akun Kedua"),
                onTap: () => Navigator.pop(context),
              ),

              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Tambah Akun"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => FirstPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
