import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/profile_avatar.dart';
import '../models/parking_model.dart';
import '../services/favorite_service.dart';
import 'parking_spot_page.dart';
import 'service_page.dart';
import 'history_page.dart';
import 'settings_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomIndex = 0;
  String searchQuery = "";

  // ================= USERNAME FROM EMAIL =================
  String usernameFromEmail(String? email) {
    if (email == null || email.isEmpty) return "User";
    final raw = email.split('@').first;
    final cleaned = raw.replaceAll(RegExp(r'[._-]'), ' ');
    return cleaned
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = usernameFromEmail(user?.email);

    final pages = [
      homeContent(),
      const HistoryPage(),
      const SettingsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: bottomIndex == 3
          ? null
          : AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  bottomIndex = 3;
                });
              },
              child: const ProfileAvatar(size: 42),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Horas 👋",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.notifications_none,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
      body: IndexedStack(index: bottomIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomIndex,
        onTap: (i) => setState(() => bottomIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  // ================= HOME CONTENT =================
  Widget homeContent() {
    final user = FirebaseAuth.instance.currentUser;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Cari tempat parkir...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        ),
        const SizedBox(height: 25),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 15,
          crossAxisSpacing: 10,
          children: [
            menu("Parking", Icons.local_parking, const ParkingSpotPage()),
            menu("Service", Icons.build, const ServicePage()),
            menu("Road Park", Icons.directions_car, const ParkingSpotPage()),
            menu("Mall", Icons.store, const ParkingSpotPage()),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          "NEARBY PARKING",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        // ================= FIREBASE PARKING LIST =================
        StreamBuilder<QuerySnapshot>(
          stream:
          FirebaseFirestore.instance.collection('parking_spots').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("Belum ada data parkir");
            }

            final docs = snapshot.data!.docs;

            final filtered = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final name = data['name'].toString().toLowerCase();
              final location = data['location'].toString().toLowerCase();
              return name.contains(searchQuery) || location.contains(searchQuery);
            }).toList();

            return ListView.builder(
              itemCount: filtered.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final data = filtered[index].data() as Map<String, dynamic>;
                final parkingId = filtered[index].id;

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('favorites')
                      .doc(parkingId)
                      .snapshots(),
                  builder: (context, favSnapshot) {
                    final isFavorite = favSnapshot.data?.exists ?? false;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_parking,
                              size: 40, color: Colors.blue),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(data['location']),
                                Text(
                                  data['price'],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: Colors.orange,
                            ),
                            onPressed: () async {
                              final favRef = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection('favorites')
                                  .doc(parkingId);

                              if (isFavorite) {
                                await favRef.delete();
                              } else {
                                await favRef.set({
                                  'name': data['name'],
                                  'location': data['location'],
                                  'price': data['price'],
                                  'createdAt': FieldValue.serverTimestamp(),
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  // ================= MENU =================
  Widget menu(String title, IconData icon, Widget page) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
