import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appcoachfutsal/fitur/penilaian/hasil_penilaian_page_2.dart';

class HasilPenilaianPage extends StatefulWidget {
  const HasilPenilaianPage({super.key});

  @override
  State<HasilPenilaianPage> createState() => _HasilPenilaianPageState();
}

class _HasilPenilaianPageState extends State<HasilPenilaianPage> {
  String? selectedPosisi;
  String? selectedPemain;
  List<String> posisiList = [];
  List<String> pemainList = [];

  @override
  void initState() {
    super.initState();
    _loadPosisi();
  }

  Future<void> _loadPosisi() async {
    final snapshot = await FirebaseFirestore.instance.collection('players').get();
    final posisiSet = <String>{};
    for (var doc in snapshot.docs) {
      posisiSet.add(doc['position'] ?? '');
    }
    setState(() {
      posisiList = posisiSet.where((e) => e.isNotEmpty).toList();
    });
  }

  Future<void> _loadPemain() async {
    if (selectedPosisi == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('players')
        .where('position', isEqualTo: selectedPosisi)
        .get();
    setState(() {
      pemainList = snapshot.docs.map((e) => e['name'] as String).toList();
    });
  }

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
              builder: (context) => const PagePenilaianPemain(),
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
                      value: selectedPosisi,
                      hint: const Text('Pilih Posisi'),
                      items: posisiList
                          .map((e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) async {
                        setState(() {
                          selectedPosisi = value;
                          selectedPemain = null;
                        });
                        await _loadPemain();
                      },
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nama Pemain',
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
                      value: selectedPemain,
                      hint: const Text('Pilih Pemain'),
                      items: pemainList
                          .map((e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPemain = value;
                        });
                      },
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
                StreamBuilder<QuerySnapshot>(
                  stream: _getPenilaianStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Terjadi error');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const Text('Belum ada penilaian');
                    }
                    return Column(
                      children: docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final nilai = data['nilai'] as Map<String, dynamic>? ?? {};
                        int total = 0;
                        for (var v in nilai.values) {
                          final n = int.tryParse(v.toString()) ?? 0;
                          total += n;
                        }
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
                                  data['pemain'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                total.toString(),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getPenilaianStream() {
    var ref = FirebaseFirestore.instance.collection('penilaian');
    if (selectedPosisi != null && selectedPemain != null) {
      return ref
          .where('posisi', isEqualTo: selectedPosisi)
          .where('pemain', isEqualTo: selectedPemain)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else if (selectedPosisi != null) {
      return ref
          .where('posisi', isEqualTo: selectedPosisi)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      return ref.orderBy('createdAt', descending: true).snapshots();
    }
  }
}