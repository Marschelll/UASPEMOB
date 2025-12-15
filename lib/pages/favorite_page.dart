import 'package:flutter/material.dart';
import '../data/favorite_data.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    debugPrint("MASUK FAVORITE PAGE");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    final favoriteList =
    parkingList.where((p) => p.isFavorite).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Favorite Parkir"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: favoriteList.isEmpty
          ? const Center(
        child: Text("Belum ada parkir favorit ⭐"),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteList.length,
        itemBuilder: (context, index) {
          final parkir = favoriteList[index];

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
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.local_parking,
                    color: Colors.blue, size: 40),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parkir.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
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
                const Icon(Icons.star, color: Colors.orange),
              ],
            ),
          );
        },
      ),
    );
  }
}
