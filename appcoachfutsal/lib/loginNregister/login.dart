import 'package:flutter/material.dart';
import 'package:appcoachfutsal/loginNregister/register.dart';
import 'package:appcoachfutsal/dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  void handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan password wajib diisi.")),
      );
      return;
    }

    try {
      // Cari email dari username di Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username tidak ditemukan.")),
        );
        return;
      }

      final userData = querySnapshot.docs.first.data();
      final email = userData['email'] as String;

      // Login dengan email dan password menggunakan Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login gagal.";
      if (e.code == 'user-not-found') {
        message = "User tidak ditemukan.";
      } else if (e.code == 'wrong-password') {
        message = "Password salah.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Selamat Datang!',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(height: 8),
                const Text('Silahkan masuk ke akun anda',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 40),
                buildInputField("Masukkan Username Anda", usernameController),
                const SizedBox(height: 16),
                buildPasswordField(),
                const SizedBox(height: 40),
                buildMainButton("Masuk", handleLogin),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum mempunyai akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const RegisterPage()));
                      },
                      child: const Text("Daftar", style: TextStyle(color: Colors.green)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFE2F2EF), borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFE2F2EF), borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: passwordController,
        obscureText: _obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Masukkan Password',
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
      ),
    );
  }

  Widget buildMainButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
