import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  final bool isReset; // Reusing screen for Forgot Password flow
  const OtpScreen({super.key, this.isReset = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isReset ? "Reset Password" : "OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isReset 
              ? "Enter your email to receive an OTP" 
              : "Enter the OTP sent to your email"),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: "Input", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success! Operation Verified.")));
                Navigator.pop(context);
              },
              child: const Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}