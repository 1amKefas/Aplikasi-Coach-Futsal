import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahKriteriaPage extends StatefulWidget {
  const TambahKriteriaPage({super.key});

  @override
  State<TambahKriteriaPage> createState() => _TambahKriteriaPageState();
}

// ...existing code...
class _TambahKriteriaPageState extends State<TambahKriteriaPage> {
  final TextEditingController kriteriaController = TextEditingController();
  // final TextEditingController targetController = TextEditingController(); // Tidak perlu lagi

  String? selectedPosisi;
  String? selectedAspek;
  String? selectedTipeKriteria;
  String? selectedTarget;
  final List<String> posisiList = ['Pivot', 'Anchor', 'Flank', 'Kiper'];
  final List<String> tipeKriteriaList = ['Core Factor', 'Secondary Factor'];
  final List<String> targetList = ['1', '2', '3', '4'];
  List<String> aspekList = [];

  @override
  void initState() {
    super.initState();
    _loadAspekList();
  }

  Future<void> _loadAspekList() async {
    final snapshot = await FirebaseFirestore.instance.collection('aspek').get();
    setState(() {
      aspekList = snapshot.docs.map((e) => e['aspek'] as String).toList();
    });
  }

  Future<void> _tambahKriteria() async {
    final posisi = selectedPosisi ?? '';
    final aspek = selectedAspek ?? '';
    final kriteria = kriteriaController.text.trim();
    final target = selectedTarget ?? '';
    final targetKriteria = selectedTipeKriteria ?? '';

    if (posisi.isEmpty || aspek.isEmpty || kriteria.isEmpty || target.isEmpty || targetKriteria.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('kriteria').add({
      'posisi': posisi,
      'aspek': aspek,
      'kriteria': kriteria,
      'target': target,
      'targetKriteria': targetKriteria,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kriteria berhasil ditambahkan')),
    );

    setState(() {
      selectedPosisi = null;
      selectedAspek = null;
      selectedTipeKriteria = null;
      selectedTarget = null;
    });
    kriteriaController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          'TAMBAH KRITERIA',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Posisi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedPosisi,
                hint: const Text('Pilih Posisi'),
                items: posisiList
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedPosisi = val;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Aspek Penilaian',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedAspek,
                hint: const Text('Pilih Aspek Penilaian'),
                items: aspekList
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedAspek = val;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Kriteria',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Pilih Kriteria*', kriteriaController),
            const SizedBox(height: 16),
            
            const Text(
              'Target',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedTarget,
                hint: const Text('Pilih Target'),
                items: targetList
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedTarget = val;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Tipe Kriteria',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedTipeKriteria,
                hint: const Text('Pilih Tipe Kriteria'),
                items: tipeKriteriaList
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedTipeKriteria = val;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _tambahKriteria,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // bikin kotak
                  ),
                ),
                child: const Text('Tambah Kriteria'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.green[50],
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
// ...existing code...