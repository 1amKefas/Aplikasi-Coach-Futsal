import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appcoachfutsal/fitur/aspek/tambah_aspek_page.dart';

class AspekPenilaianPage extends StatefulWidget {
  const AspekPenilaianPage({super.key});

  @override
  State<AspekPenilaianPage> createState() => _AspekPenilaianPageState();
}

class _AspekPenilaianPageState extends State<AspekPenilaianPage> {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('aspek').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Belum ada aspek'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildAspekCard(
                  context: context,
                  docId: doc.id,
                  aspek: data['aspek'] ?? '',
                  persentase: data['persentase'] ?? '',
                  core: data['core'] ?? '',
                  secondary: data['secondary'] ?? '',
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
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

  Widget _buildAspekCard({
    required BuildContext context,
    required String docId,
    required String aspek,
    required String persentase,
    required String core,
    required String secondary,
  }) {
    final TextEditingController aspekController = TextEditingController(text: aspek);
    final TextEditingController persentaseController = TextEditingController(text: persentase);
    final TextEditingController coreController = TextEditingController(text: core);
    final TextEditingController secondaryController = TextEditingController(text: secondary);

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
              children: [
                Text(
                  aspek,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.groups_2_outlined),
              ],
            ),

            const SizedBox(height: 4),
            const Divider(thickness: 1),
            const SizedBox(height: 4),

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
                // Nilai %/angka
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$persentase %'),
                    const SizedBox(height: 4),
                    Text('$core %'),
                    const SizedBox(height: 4),
                    Text('$secondary %'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),
            const Divider(thickness: 1),
            const SizedBox(height: 4),

            // Edit & Delete Buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Edit Aspek'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: aspekController,
                                decoration: const InputDecoration(labelText: 'Aspek Penilaian'),
                              ),
                              TextFormField(
                                controller: persentaseController,
                                decoration: const InputDecoration(labelText: 'Persentase'),
                                keyboardType: TextInputType.number,
                              ),
                              TextFormField(
                                controller: coreController,
                                decoration: const InputDecoration(labelText: 'Core Factor'),
                                keyboardType: TextInputType.number,
                              ),
                              TextFormField(
                                controller: secondaryController,
                                decoration: const InputDecoration(labelText: 'Secondary Factor'),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance.collection('aspek').doc(docId).update({
                                'aspek': aspekController.text.trim(),
                                'persentase': persentaseController.text.trim(),
                                'core': coreController.text.trim(),
                                'secondary': secondaryController.text.trim(),
                              });
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Aspek berhasil diupdate')),
                              );
                              setState(() {});
                            },
                            child: const Text('Simpan'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('Edit'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Aspek'),
                        content: const Text('Yakin ingin menghapus aspek ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await FirebaseFirestore.instance.collection('aspek').doc(docId).delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Aspek berhasil dihapus')),
                      );
                      setState(() {});
                    }
                  },
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
              ],
            )
          ],
        ),
      ),
    );
  }
}