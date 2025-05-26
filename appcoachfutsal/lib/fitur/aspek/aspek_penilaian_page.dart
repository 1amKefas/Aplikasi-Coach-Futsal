import 'package:flutter/material.dart';

// Update Tambah Aspek Page
import 'package:appcoachfutsal/fitur/aspek/tambah_aspek_page.dart';

class AspekPenilaianPage extends StatelessWidget {
  const AspekPenilaianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          'ASPEK PENILAIAN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: List.generate(5, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAspekCard(),
        ))..add(const SizedBox(height: 100)), // Tambahan spacing untuk FAB
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // aksi tambah aspek
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahAspekPage()),
          );
        },
        backgroundColor: Colors.orange[300],
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text('New Aspect'),
      ),
    );
  }

  Widget _buildAspekCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Nama Aspek + Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Nama Aspek',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.groups_2_outlined),
              ],
            ),

            // Garis pembatas
            const SizedBox(height: 4), // Lebih rapat sebelum divider
            const Divider(thickness: 1),
            const SizedBox(height: 4), // Lebih rapat setelah divider

            // Bagian isi faktor: label kiri - angka kanan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Persentase'),
                      SizedBox(height: 4),
                      Text('Core Factor'),
                      SizedBox(height: 4),
                      Text('Secondary Factor'),
                    ],
                  ),
                ),
                // Nilai %
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('40 %'),
                    SizedBox(height: 4),
                    Text('60 %'),
                    SizedBox(height: 4),
                    Text('40 %'),
                  ],
                ),
              ],
            ),

            // Garis pembatas
            const SizedBox(height: 4), // Lebih rapat sebelum divider
            const Divider(thickness: 1),
            const SizedBox(height: 4), // Lebih rapat setelah divider

            // Edit & Delete Buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    foregroundColor: Colors.white, // Warna teks jadi putih
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('Edit'),
                ),
                // Geser tombol Delete sedikit ke kanan
                Padding(
                  padding: const EdgeInsets.only(left: 175.0), // Ubah nilai sesuai selera
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BottomNavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
