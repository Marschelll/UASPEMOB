import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A6275),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "HORAS!",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "Pixel",
              ),
            ),

            const SizedBox(height: 40),

            // Logo
            Image.asset("assets/logo.png", width: 180),

            const SizedBox(height: 50),

            // Sign Up Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(200, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage())),
              child: const Text("Sign Up"),
            ),

            const SizedBox(height: 15),

            // Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(200, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage())),
              child: const Text("Login", style: TextStyle(color: Colors.black)),
            ),

            const SizedBox(height: 30),

            const Text(
              "Solusi Paten Cari Parkir Lae!",
              style: TextStyle(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}
