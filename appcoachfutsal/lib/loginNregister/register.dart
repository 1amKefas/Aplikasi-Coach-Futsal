import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appcoachfutsal/loginNregister/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  Future<bool> isUsernameAvailable(String username) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return query.docs.isEmpty;
  }

  void handleRegister() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi.")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password dan konfirmasi password tidak sama.")),
      );
      return;
    }

    if (!await isUsernameAvailable(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username sudah digunakan, coba yang lain.")),
      );
      return;
    }

    try {
      // Register di Firebase Auth pake email/password
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Simpan username dan email ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil, silahkan login.")),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
    } on FirebaseAuthException catch (e) {
      String message = "Registrasi gagal.";
      if (e.code == 'email-already-in-use') {
        message = "Email sudah terdaftar.";
      } else if (e.code == 'weak-password') {
        message = "Password terlalu lemah.";
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Buat Akun Baru",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(height: 8),
                const Text("Silahkan isi data berikut untuk mendaftar",
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 40),
                buildInputField("Username", usernameController),
                const SizedBox(height: 16),
                buildInputField("Email", emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                buildPasswordField("Password", passwordController),
                const SizedBox(height: 16),
                buildPasswordField("Konfirmasi Password", confirmPasswordController),
                const SizedBox(height: 40),
                buildMainButton("Daftar", handleRegister),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (_) => const LoginPage()));
                      },
                      child: const Text("Masuk", style: TextStyle(color: Colors.green)),
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

  Widget buildInputField(String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFE2F2EF), borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: hint, hintStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget buildPasswordField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFE2F2EF), borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
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
