import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simulate registration success
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account Created! Please Login.")));
                  Navigator.pop(context);
                },
                child: const Text("Create Account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}