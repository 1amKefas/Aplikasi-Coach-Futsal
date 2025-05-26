import 'package:flutter/material.dart';
import 'package:appcoachfutsal/fitur/kriteria/list_kriteria.dart';
import 'package:appcoachfutsal/fitur/player/player_detail_page.dart';
import 'dart:async';
import 'package:appcoachfutsal/fitur/player/player_list_page.dart';
import 'package:appcoachfutsal/fitur/player/add_player_page.dart';
import 'package:appcoachfutsal/SplashScreen/splash1.dart';
import 'package:appcoachfutsal/SplashScreen/splash2.dart';

// Update Page Profile
import 'package:appcoachfutsal/fitur/profile/profile_page.dart';

// Update Aspek Penilaian Page
import 'package:appcoachfutsal/fitur/aspek/aspek_penilaian_page.dart';

// Update Hasil Penilaian Page
import 'package:appcoachfutsal/fitur/penilaian/hasil_penilaian_page.dart';

import 'package:appcoachfutsal/fitur/lineup/LineUp_page.dart';
import 'package:appcoachfutsal/fitur/statistik/statistic_pemain.dart';
import 'package:appcoachfutsal/fitur/jadwal/atur_jadwal_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // harus sesuai file dari flutterfire configure
import 'package:appcoachfutsal/dashboard/dashboard.dart';



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

