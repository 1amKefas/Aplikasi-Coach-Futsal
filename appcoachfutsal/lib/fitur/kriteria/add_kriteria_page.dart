import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahKriteriaPage extends StatefulWidget {
  const TambahKriteriaPage({super.key});

  @override
  State<TambahKriteriaPage> createState() => _TambahKriteriaPageState();
}

class _TambahKriteriaPageState extends State<TambahKriteriaPage> {
  final TextEditingController posisiController = TextEditingController();
  final TextEditingController aspekController = TextEditingController();
  final TextEditingController kriteriaController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController targetKriteriaController = TextEditingController();

  Future<void> _tambahKriteria() async {
    final posisi = posisiController.text.trim();
    final aspek = aspekController.text.trim();
    final kriteria = kriteriaController.text.trim();
    final target = targetController.text.trim();
    final targetKriteria = targetKriteriaController.text.trim();

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

    posisiController.clear();
    aspekController.clear();
    kriteriaController.clear();
    targetController.clear();
    targetKriteriaController.clear();
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
            _buildInputField('Pilih Posisi', posisiController),
            const SizedBox(height: 16),

            const Text(
              'Aspek Penilaian',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Masukkan Aspek*', aspekController),
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
            _buildInputField('Masukkan Target*', targetController),
            const SizedBox(height: 16),

            const Text(
              'Target Kriteria',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Pilih Target Kriteria*', targetKriteriaController),
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