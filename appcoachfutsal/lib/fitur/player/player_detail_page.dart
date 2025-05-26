import 'package:flutter/material.dart';

class PlayerDetailPage extends StatelessWidget {
  final String name;
  final String position;
  final int number;
  final String imageAsset;

  const PlayerDetailPage({
    super.key,
    required this.name,
    required this.position,
    required this.number,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'DATA PEMAIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card pemain
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  // Foto Pemain
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  const SizedBox(width: 12),

                  // Info Pemain
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Posisi
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          position.toUpperCase(),
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Nama
                      Text(
                        name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Nomor Punggung
                  Text(
                    number.toString(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Detail Lainnya
            Container(
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nama: Emi Martinez", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Kewarganegaraan: Argentina", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Umur: 27", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Tinggi: 192cm", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Berat: 90kg", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Transfer: 20m", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


