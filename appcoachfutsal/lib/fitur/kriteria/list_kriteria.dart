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
              final aspek = data['aspek'] ?? '';
              final kriteria = data['kriteria'] ?? '';
              final target = data['target'] ?? '';
              final targetKriteria = data['targetKriteria'] ?? '';

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Nama Kriteria + Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            kriteria,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.groups_2_outlined),
                        ],
                      ),
                      // Tambahkan aspek di bawah kriteria
                      const SizedBox(height: 4),
                      Text(
                        aspek,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.55),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // ...lanjutkan kode seperti biasa...
                      const Divider(thickness: 1),
                      const SizedBox(height: 4),
                      // Aspek penilaian, kecil & transparan
                      const SizedBox(height: 12),
                      // Bagian isi faktor: label kiri - angka kanan
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Target:'),
                                SizedBox(height: 4),
                                Text('Tipe:'),
                              ],
                            ),
                          ),
                          // Nilai
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(target),
                              const SizedBox(height: 4),
                              Text(targetKriteria),
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
                                  title: const Text('Edit Kriteria'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          initialValue: kriteria,
                                          decoration: const InputDecoration(labelText: 'Kriteria'),
                                          onChanged: (val) => data['kriteria'] = val,
                                        ),
                                        TextFormField(
                                          initialValue: aspek,
                                          decoration: const InputDecoration(labelText: 'Aspek Penilaian'),
                                          onChanged: (val) => data['aspek'] = val,
                                        ),
                                        TextFormField(
                                          initialValue: target,
                                          decoration: const InputDecoration(labelText: 'Target'),
                                          onChanged: (val) => data['target'] = val,
                                        ),
                                        TextFormField(
                                          initialValue: targetKriteria,
                                          decoration: const InputDecoration(labelText: 'Tipe Kriteria'),
                                          onChanged: (val) => data['targetKriteria'] = val,
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
                                          'kriteria': data['kriteria'],
                                          'aspek': data['aspek'],
                                          'target': data['target'],
                                          'targetKriteria': data['targetKriteria'],
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
                                  title: const Text('Hapus Kriteria'),
                                  content: const Text('Yakin ingin menghapus kriteria ini?'),
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
                                await FirebaseFirestore.instance.collection('kriteria').doc(doc.id).delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Kriteria berhasil dihapus')),
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