import 'package:flutter/material.dart';

// Update Hasil Penilaian Page 2
import 'package:appcoachfutsal/fitur/penilaian/hasil_penilaian_page_2.dart';

class HasilPenilaianPage extends StatelessWidget {
  const HasilPenilaianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'HASIL PENILAIAN PEMAIN',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PagePenilaianPemain(), // ganti sesuai nama class Page 2 kamu
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Posisi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade100),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: null,
                      hint: const Text('Pilih Posisi'),
                      items: const [],
                      onChanged: (value) {},
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nama Pemain', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Total Nilai', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._buildPlayerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPlayerList() {
    final players = [
      {'name': 'Jay Idzes', 'score': '90'},
      {'name': 'Tom Haye', 'score': '90'},
      {'name': 'Rizky Ridho', 'score': '99'},
      {'name': 'Marselino', 'score': '99'},
      {'name': 'Nathan Tjoe', 'score': '65'},
    ];

    return players.map((player) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                player['name']!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              player['score']!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }).toList();
  }
}
