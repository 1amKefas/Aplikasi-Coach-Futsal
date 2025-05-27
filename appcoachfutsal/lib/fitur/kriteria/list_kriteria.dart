import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appcoachfutsal/fitur/kriteria/add_kriteria_page.dart';

class DataKriteriaPage extends StatefulWidget {
  const DataKriteriaPage({super.key});

  @override
  State<DataKriteriaPage> createState() => _DataKriteriaPageState();
}

class _DataKriteriaPageState extends State<DataKriteriaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'KRITERIA PENILAIAN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('kriteria').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Belum ada kriteria'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final posisi = data['posisi'] ?? '';
              final aspek = data['aspek'] ?? '';
              final kriteria = data['kriteria'] ?? '';
              final target = data['target'] ?? '';
              final targetKriteria = data['targetKriteria'] ?? '';

              final aspekController = TextEditingController(text: aspek);
              final posisiController = TextEditingController(text: posisi);
              final kriteriaController = TextEditingController(text: kriteria);
              final targetController = TextEditingController(text: target);
              final targetKriteriaController = TextEditingController(text: targetKriteria);

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(aspek, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const Icon(Icons.groups),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Posisi: $posisi'),
                      Text('Kriteria: $kriteria'),
                      Text('Target: $target'),
                      Text('Target Kriteria: $targetKriteria'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Edit Kriteria'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: posisiController,
                                          decoration: const InputDecoration(labelText: 'Posisi'),
                                        ),
                                        TextFormField(
                                          controller: aspekController,
                                          decoration: const InputDecoration(labelText: 'Aspek Penilaian'),
                                        ),
                                        TextFormField(
                                          controller: kriteriaController,
                                          decoration: const InputDecoration(labelText: 'Kriteria'),
                                        ),
                                        TextFormField(
                                          controller: targetController,
                                          decoration: const InputDecoration(labelText: 'Target'),
                                        ),
                                        TextFormField(
                                          controller: targetKriteriaController,
                                          decoration: const InputDecoration(labelText: 'Target Kriteria'),
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
                                        await FirebaseFirestore.instance.collection('kriteria').doc(doc.id).update({
                                          'posisi': posisiController.text.trim(),
                                          'aspek': aspekController.text.trim(),
                                          'kriteria': kriteriaController.text.trim(),
                                          'target': targetController.text.trim(),
                                          'targetKriteria': targetKriteriaController.text.trim(),
                                        });
                                        Navigator.pop(ctx);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Kriteria berhasil diupdate')),
                                        );
                                        setState(() {});
                                      },
                                      child: const Text('Simpan'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Edit'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Hapus Kriteria'),
                                  content: const Text('Yakin ingin menghapus kriteria ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await FirebaseFirestore.instance.collection('kriteria').doc(doc.id).delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Kriteria berhasil dihapus')),
                                );
                                setState(() {});
                              }
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TambahKriteriaPage()));
        },
        icon: const Icon(Icons.add),
        label: const Text('New Kriteria'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}