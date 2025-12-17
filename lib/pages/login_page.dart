import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A6275),

      // 🔙 BACK BUTTON TETAP ADA
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A6275),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text("Welcome",
                style: TextStyle(fontSize: 35, color: Colors.white)),
            const Text("Back",
                style: TextStyle(fontSize: 35, color: Colors.white)),

            const SizedBox(height: 40),

            // EMAIL
            TextField(
              controller: email,
              style: const TextStyle(color: Colors.white),
              decoration: _input("Email"),
            ),
            const SizedBox(height: 15),

            // PASSWORD
            TextField(
              controller: password,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _input("Password"),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                ),
                child: const Text(
                  "Lupa Password?",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 LOGIN BUTTON + FIREBASE
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: email.text.trim(),
                    password: password.text.trim(),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(e.message ?? "Login gagal")),
                  );
                }
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF4A5163),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
