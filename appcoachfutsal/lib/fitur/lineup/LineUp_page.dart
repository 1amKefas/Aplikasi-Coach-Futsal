import 'package:flutter/material.dart';

class LineUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          'LINE UP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Lapangan dan pemain utama
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/lapangan.png'), // Ganti dengan path gambar lapangan lo
                  // Pemain utama (posisi disesuaikan)
                  Positioned(top: 180, child: playerIcon('red')),
                  Positioned(top: 300, left: 80, child: playerIcon('red')),
                  Positioned(top: 300, right: 80, child: playerIcon('red')),
                  Positioned(top: 350, child: playerIcon('red')),
                  Positioned(bottom: 125, child: playerIcon('blue')), // Keeper
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Pemain Cadangan
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Pemain Cadangan',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(5, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ],
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              index < 2
                                  ? 'assets/images/jersey2.png'
                                  : 'assets/images/jersey1.png',
                              height: 40,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Player Sub',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget playerIcon(String color) {
    return Image.asset(
      color == 'red' ? 'assets/images/jersey1.png' : 'assets/images/jersey2.png',
      height: 70,
    );
  }
}
