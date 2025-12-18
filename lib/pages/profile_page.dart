import 'package:flutter/material.dart';
import '../widgets/profile_avatar.dart';
import 'my_vehicle_page.dart';
import 'favorite_page.dart';
import 'first_page.dart';
import 'address_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ================= USERNAME FROM EMAIL =================
  String _usernameFromEmail(String? email) {
    if (email == null || email.isEmpty) return "User";

    final rawName = email.split('@').first;
    final cleaned = rawName.replaceAll(RegExp(r'[._-]'), ' ');

    return cleaned
        .split(' ')
        .map((word) =>
    word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1)
        : '')
        .join(' ');
  }

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

      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          final username = _usernameFromEmail(user?.email);

          return Column(
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

              // ===== USERNAME (REALTIME FROM EMAIL) =====
              Text(
                username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Indonesia",
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

              // ================= EMAIL =================
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.email, color: Colors.blue, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        user?.email ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
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
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
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
          );
        },
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
                title: const Text("Akun Aktif"),
                trailing: const Icon(Icons.check, color: Colors.green),
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
