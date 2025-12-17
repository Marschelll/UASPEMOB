import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alamat Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddress(context),
        child: const Icon(Icons.add),
      ),

      // 🔥 LIST ALAMAT DARI FIREBASE
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('addresses')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada alamat"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['detail'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ➕ TAMBAH ALAMAT (FIREBASE)
  void _showAddAddress(BuildContext context) {
    final titleController = TextEditingController();
    final detailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tambah Alamat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Nama Alamat (Rumah, Kantor)",
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: detailController,
                decoration: const InputDecoration(
                  labelText: "Detail Alamat",
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      detailController.text.isEmpty) return;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('addresses')
                      .add({
                    'title': titleController.text.trim(),
                    'detail': detailController.text.trim(),
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        );
      },
    );
  }
}
