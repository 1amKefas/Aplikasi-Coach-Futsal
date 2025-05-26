import 'package:flutter/material.dart';

class TambahKriteriaPage extends StatelessWidget {
  const TambahKriteriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController aspekController = TextEditingController();
    final TextEditingController kriteriaController = TextEditingController();
    final TextEditingController targetController = TextEditingController();
    final TextEditingController targetKriteriaController = TextEditingController();

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
            _buildInputField('Pilih Posisi'),
            const SizedBox(height: 16),

            const Text(
              'Aspek Penilaian',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Masukkan Aspek*'),
            const SizedBox(height: 16),

            const Text(
              'Kriteria',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Pilih Kriteria*'),
            const SizedBox(height: 16),
            
            const Text(
              'Target',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Masukkan Aspek*'),
            const SizedBox(height: 16),

            const Text(
              'Target Kriteria',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Pilih Kriteria*'),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // aksi tambah aspek
                },
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
}

  Widget _buildInputField(String hint) {
    return TextFormField(
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

