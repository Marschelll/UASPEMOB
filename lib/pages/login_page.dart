import 'package:flutter/material.dart';
import 'forgot_password.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A6275),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome",
                style: TextStyle(fontSize: 35, color: Colors.white)),
            const Text("Back",
                style: TextStyle(fontSize: 35, color: Colors.white)),
            const SizedBox(height: 40),

            // Email
            TextField(
              controller: email,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF4A5163),
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),

            // Password
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF4A5163),
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ForgotPasswordPage())),
                child: const Text("Lupa Password?",
                    style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 25),

            // Login button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => HomePage()));
              },
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
