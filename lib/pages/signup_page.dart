import 'package:flutter/material.dart';

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
        title: const Text("SignUP"),
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

            // Sign Up Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 45),
                backgroundColor: Colors.blue,
              ),
              onPressed: () {},
              child: const Text("SignUp"),
            )
          ],
        ),
      ),
    );
  }

  Widget textField(String label, TextEditingController c,
      {bool obscure = false}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
