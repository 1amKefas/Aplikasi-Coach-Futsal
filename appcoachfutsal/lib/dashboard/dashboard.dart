import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
 // harus sesuai file dari flutterfire configure

Future<String> getUserName() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data()?['username'] ?? 'User';
    }
  }
  return 'User';
}

String _bulanIndo(int bulan) {
  const bulanIndo = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];
  return bulanIndo[bulan];
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<String>(
                        future: getUserName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text('Hello,\nLoading...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                          } else if (snapshot.hasError) {
                            return Text('Hello,\nError', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                          } else {
                            return Text(
                              'Hello,\n${snapshot.data}',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            );
                          }
                        },
                      )
              ),

              // Profile singkat
              buildProfileSection(),

              // Gambar singa biru
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Center( // Tambahin ini
                  child: Image.asset(
                    'assets/images/singa.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),


              const SizedBox(height: 20),

              // Fitur section
              sectionTitle('Fitur'),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      fiturCard(Icons.calendar_month, 'Atur Jadwal', context),
                      fiturCard(Icons.person_2, 'Data Pemain', context),
                      fiturCard(Icons.track_changes, 'Data Aspek', context),
                      fiturCard(Icons.sports_soccer, 'Data Kriteria', context),
                      fiturCard(Icons.fact_check, 'Penilaian', context),
                      fiturCard(Icons.stacked_bar_chart, 'Statistik', context),
                      fiturCard(Icons.person, 'Profile', context),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Statistik Section
              sectionTitle('Statistik'),
              const SizedBox(height: 12),
              buildStatistikSection(),

              const SizedBox(height: 20),

              // Jadwal section
              sectionTitle('Jadwal'),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('jadwal').orderBy('tanggal').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Terjadi error saat mengambil jadwal'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Belum ada jadwal'),
                    );
                  }
                  return Column(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final tanggal = (data['tanggal'] as Timestamp).toDate();
                      final jam = data['jam'] ?? '';
                      final lokasi = data['lokasi'] ?? '';
                      return jadwalCard(
                        'Latihan',
                        // Format tanggal
                        '${tanggal.day.toString().padLeft(2, '0')} ${_bulanIndo(tanggal.month)}, ${tanggal.year}',
                        jam,
                        lokasi,
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

     floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            bottomNavItem(Icons.home, 'Home', () {
              // navigasi ke halaman Home
            }),
            bottomNavItem(Icons.group, 'Pemain', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerListPage())
              );
            }),
            bottomNavItem(Icons.format_list_bulleted, 'Line Up', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LineUpPage()),
              );
            }),
            bottomNavItem(Icons.logout, 'Logout', () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            })
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget fiturCard(IconData icon, String label, BuildContext context) {
    return InkWell(
      onTap: () {
        if (label == 'Data Pemain') {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlayerListPage(),
          ),
        );
        }

        // Update Page Profile
        else if (label == 'Profile') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfilePage(),
            ),
          );
        }

        // Update Aspek Penilaian Page
        else if (label == 'Data Aspek') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AspekPenilaianPage(),
            ),
          );
        }

        // Update Hasil Penilaian Page
        else if (label == 'Penilaian') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HasilPenilaianPage()),
          );
        }

        else if (label == 'Data Kriteria') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DataKriteriaPage()),
          );
        }

        else if (label == 'Statistik') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) =>  StatistikPemainPage()),
          );
        }

        else if (label == 'Atur Jadwal') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) =>  const AturJadwalPage()),
          );
        }

        // bisa tambahin else if lainnya kalau ada fitur lain
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fitur "$label" belum tersedia')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: SizedBox(
          width: 80,
          child: Column(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2))
                  ],
                ),
                child: Icon(icon, size: 28),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }





 Widget jadwalCard(String title, String date, String time, String location) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sports, size: 20),
                SizedBox(width: 8),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 6),
                Text('$date\n$time'),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16),
                    SizedBox(width: 4),
                    Text(location, textAlign: TextAlign.right),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget bottomNavItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }


  Widget buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kefas Hutabarat', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Manajer Tim', style: TextStyle(color: Colors.grey[600])),
            ],
          )
        ],
      ),
    );
  }

  Widget buildStatistikSection() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 8),
        children: [
          statistikCard('Total Pemain', '15'),
          statistikCard('Line Up', '5'),
          statistikCard('Latihan Selesai', '12'),
          statistikCard('Penilaian', '27'),
        ],
      ),
    );
  }

  Widget statistikCard(String label, String value) {
    return Container(
      width: 140,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
