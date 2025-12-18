import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final pass2 = TextEditingController();

  // ================= GOOGLE SIGN UP =================
  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      User user = userCredential.user!;

      // 🔥 SIMPAN USERNAME GOOGLE KE FIRESTORE
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'username': user.displayName ?? 'User',
        'email': user.email,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign Up dengan Google berhasil")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ================= EMAIL SIGN UP =================
  Future<void> signUp(BuildContext context) async {
    if (pass.text != pass2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak sama")),
      );
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text.trim(),
      );

      // 🔥 SIMPAN USERNAME EMAIL KE FIRESTORE
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': name.text.trim(),
        'email': email.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akun berhasil dibuat")),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Gagal daftar")),
      );
    }
  }

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

            // ================= EMAIL SIGN UP =================
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 45),
                backgroundColor: Colors.blue,
              ),
              onPressed: () => signUp(context),
              child: const Text("Sign Up"),
            ),

            const SizedBox(height: 15),

            // ================= GOOGLE SIGN UP =================
            OutlinedButton.icon(
              icon: Image.asset(
                'assets/signupp.png',
                height: 22,
              ),
              label: const Text(""),
              onPressed: () => signUpWithGoogle(context),
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
