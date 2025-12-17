import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatelessWidget {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final pass2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A6275),
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  textField("Nama lengkap", name),
                  const SizedBox(height: 15),
                  textField("Email", email),
                  const SizedBox(height: 15),
                  textField("Masukkan password", pass, obscure: true),
                  const SizedBox(height: 15),
                  textField("Masukkan ulang password", pass2, obscure: true),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // SIGN UP BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 45),
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                if (pass.text != pass2.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password tidak sama"),
                    ),
                  );
                  return;
                }

                try {
                  // 1️⃣ Buat akun di Firebase Auth
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text.trim(),
                    password: pass.text.trim(),
                  );

                  // 2️⃣ Ambil UID user
                  final user = userCredential.user;

                  // 3️⃣ Simpan data user ke Firestore
                  await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
                    'name': name.text.trim(),
                    'email': email.text.trim(),
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Akun berhasil dibuat"),
                    ),
                  );

                  Navigator.pop(context); // kembali ke login
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? "Gagal daftar"),
                    ),
                  );
                }
              },

              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TEXT FIELD =================
  Widget textField(
      String label,
      TextEditingController controller, {
        bool obscure = false,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
