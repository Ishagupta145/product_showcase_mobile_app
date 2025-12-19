import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Read from SharedPreferences
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? 'John Doe';
      _emailController.text = prefs.getString('email') ?? 'john@example.com';
      String? imgPath = prefs.getString('profile_image');
      if (imgPath != null) _imageFile = File(imgPath);
    });
  }

  // Save to SharedPreferences
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    if (_imageFile != null) {
      await prefs.setString('profile_image', _imageFile!.path);
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Saved!")));
  }

  // Pick Image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null ? const Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveProfile, child: const Text("Save Changes")),
            const Divider(height: 40),
            TextButton(
              onPressed: () {
                context.read<AuthProvider>().logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}