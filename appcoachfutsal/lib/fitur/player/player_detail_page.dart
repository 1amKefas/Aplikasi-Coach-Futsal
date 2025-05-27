import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerDetailPage extends StatefulWidget {
  final String name;
  final String position;
  final int number;
  final String imageAsset;

  const PlayerDetailPage({
    super.key,
    required this.name,
    required this.position,
    required this.number,
    required this.imageAsset,
  });

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  final TextEditingController descController = TextEditingController();
  String? docId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerDesc();
  }

  Future<void> _loadPlayerDesc() async {
    // Cari dokumen player berdasarkan nama, nomor, dan posisi
    final query = await FirebaseFirestore.instance
        .collection('players')
        .where('name', isEqualTo: widget.name)
        .where('number', isEqualTo: widget.number.toString())
        .where('position', isEqualTo: widget.position)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      docId = query.docs.first.id;
      descController.text = query.docs.first.data()['desc'] ?? '';
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveDesc() async {
    if (docId != null) {
      await FirebaseFirestore.instance
          .collection('players')
          .doc(docId)
          .update({'desc': descController.text});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deskripsi berhasil disimpan')),
      );
    }
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
          'DATA PEMAIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Card pemain
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
                    ),
                    child: Row(
                      children: [
                        // Foto Pemain
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(widget.imageAsset),
                        ),
                        const SizedBox(width: 12),

                        // Info Pemain
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Posisi
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.position.toUpperCase(),
                                style: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Nama
                            Text(
                              widget.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Nomor Punggung
                        Text(
                          widget.number.toString(),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Deskripsi yang bisa diedit
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Deskripsi Pemain:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: descController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Tulis deskripsi/keterangan pemain di sini...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveDesc,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Simpan Deskripsi"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}