import 'package:flutter/material.dart';
import 'package:appcoachfutsal/fitur/player/player_list_page.dart';
import 'package:appcoachfutsal/fitur/player/add_player_page.dart';
import 'package:appcoachfutsal/SplashScreen/splash1.dart';

// Update Page Profile

// Update Aspek Penilaian Page

// Update Hasil Penilaian Page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// harus sesuai file dari flutterfire configure



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // WAJIB sebelum Firebase digunakan
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Futsal App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/player-list': (context) => const PlayerListPage(),
        '/add-player': (context) => const AddPlayerPage(),
        // tambahkan semua route lain juga kalau perlu
      },
      home: const SplashScreen(), // ← SplashScreen di sini, bukan di main()
    );
  }
}


// Dummy in-memory database
void addUser(String name, String email) {
  FirebaseFirestore.instance.collection('users').add({
    'name': name,
    'email': email,
    'createdAt': Timestamp.now(),
  });
}

