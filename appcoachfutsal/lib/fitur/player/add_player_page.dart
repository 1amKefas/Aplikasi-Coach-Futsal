import 'package:flutter/material.dart';

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({super.key});

  @override
  State<AddPlayerPage> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  String? selectedPosition;

  final List<String> positions = ['KIPER', 'FLANK', 'ANCHOR', 'MIDFIELD'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.grey[100],
     appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'TAMBAH PEMAIN',
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
              'Nama Pemain',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Masukkan Nama Pemain'),
            const SizedBox(height: 16),

            const Text(
              'Posisi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Pilih Posisi'),
            const SizedBox(height: 16),

            const Text(
              'Nomor Punggung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField('Masukkan Nomor Punggung'),
            const SizedBox(height: 16),



            const SizedBox(height: 40),

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
                child: const Text('Tambah Pemain'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Player {
  final String name;
  final String position;
  final String number;

  Player({required this.name, required this.position, required this.number});
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

