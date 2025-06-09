import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> _addPlayer() async {
    final name = nameController.text.trim();
    final number = numberController.text.trim();
    final position = selectedPosition;

    if (name.isEmpty || number.isEmpty || position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    // Cek apakah nomor punggung sudah ada
    final existingNumber = await FirebaseFirestore.instance
        .collection('players')
        .where('number', isEqualTo: number)
        .get();

    if (existingNumber.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor punggung sudah terdaftar!')),
      );
      return;
    }

    // Cek apakah nama sudah ada
    final existingName = await FirebaseFirestore.instance
        .collection('players')
        .where('name', isEqualTo: name)
        .get();

    if (existingName.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama pemain sudah terdaftar!')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('players').add({
      'name': name,
      'number': number,
      'position': position,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pemain berhasil ditambahkan')),
    );

    nameController.clear();
    numberController.clear();
    setState(() {
      selectedPosition = null;
    });
    Navigator.pop(context); // Kembali ke halaman sebelumnya
  }

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
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.green[50],
                hintText: 'Masukkan Nama Pemain',
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Posisi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPosition,
              items: positions
                  .map((pos) => DropdownMenuItem(
                        value: pos,
                        child: Text(pos),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedPosition = val;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.green[50],
                hintText: 'Pilih Posisi',
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Nomor Punggung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.green[50],
                hintText: 'Masukkan Nomor Punggung',
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _addPlayer,
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