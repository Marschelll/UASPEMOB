import 'package:flutter/material.dart';
import '../data/favorite_data.dart';
import '../widgets/profile_avatar.dart';

import 'parking_spot_page.dart';
import 'service_page.dart';
import 'road_park_page.dart';
import 'mall_parking_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      homeContent(),          // 🔥 dibuat ulang saat rebuild
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

        title: Row(
          children: [
            // 👤 AVATAR (TAMPILAN SAJA)
            GestureDetector(
              onTap: () {
                setState(() {
                  bottomIndex = 3; // 👉 pindah ke ProfilePage
                });
              },
              child: const ProfileAvatar(size: 42),
            ),


            const SizedBox(width: 12),

            // 👋 TEXT
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Horas 👋",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Jordi Sibero",
                  style: TextStyle(
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


      body: IndexedStack(
        index: bottomIndex,
        children: pages,
      ),

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
            menu("Road Park", Icons.directions_car, const RoadParkPage()),
            menu("Mall", Icons.store, const MallParkingPage()),
          ],
        ),

        const SizedBox(height: 30),

        const Text(
          "NEARBY PARKING",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 15),

        ListView.builder(
          itemCount: parkingList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final parkir = parkingList[index];

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
                          parkir.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(parkir.location),
                        Text(
                          parkir.price,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  // ⭐ FAVORITE BUTTON
                  IconButton(
                    icon: Icon(
                      parkir.isFavorite
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        parkir.isFavorite = !parkir.isFavorite;
                      });
                    },
                  ),
                ],
              ),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
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

  // ================= CARD =================
  Widget parkingCard(String name, String location, String price) {
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
          const Icon(Icons.local_parking, color: Colors.blue, size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(location),
                Text(price,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
