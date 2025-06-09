import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appcoachfutsal/fitur/player/player_list_page.dart';

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

  // Tambahan untuk edit
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String? selectedPosition;
  final List<String> positions = ['KIPER', 'FLANK', 'ANCHOR', 'MIDFIELD'];

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
      // Set initial value for edit
      nameController.text = widget.name;
      numberController.text = widget.number.toString();
      selectedPosition = widget.position;
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

  Future<void> _editPlayer() async {
    final newName = nameController.text.trim();
    final newNumber = numberController.text.trim();
    final newPosition = selectedPosition;

    if (newName.isEmpty || newNumber.isEmpty || newPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    // Cek apakah nama dan nomor punggung sudah ada (kecuali data sendiri)
    final query = await FirebaseFirestore.instance
        .collection('players')
        .where('name', isEqualTo: newName)
        .where('number', isEqualTo: newNumber)
        .get();

    bool isDuplicate = false;
    for (var doc in query.docs) {
      if (doc.id != docId) {
        isDuplicate = true;
        break;
      }
    }

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan nomor punggung sudah terdaftar!')),
      );
      return;
    }

    // Update data
    await FirebaseFirestore.instance.collection('players').doc(docId).update({
      'name': newName,
      'number': newNumber,
      'position': newPosition,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data pemain berhasil diupdate')),
    );

    setState(() {
      // Update tampilan
    });
    Navigator.pop(context); // Tutup dialog
  }

  Future<void> _deletePlayer() async {
    if (docId != null) {
      await FirebaseFirestore.instance.collection('players').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pemain berhasil dihapus')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PlayerListPage()),
        (route) => false 
      ); // Kembali ke list
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Pemain'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Pemain'),
              ),
              const SizedBox(height: 12),
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
                decoration: const InputDecoration(labelText: 'Posisi'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nomor Punggung'),
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
            onPressed: _editPlayer,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pemain'),
        content: const Text('Yakin ingin menghapus pemain ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _deletePlayer,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.orange),
            onPressed: _showEditDialog,
            tooltip: 'Edit Pemain',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _showDeleteDialog,
            tooltip: 'Hapus Pemain',
          ),
        ],
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
                                (selectedPosition ?? widget.position).toUpperCase(),
                                style: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Nama
                            Text(
                              nameController.text.isNotEmpty ? nameController.text : widget.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Nomor Punggung
                        Text(
                          numberController.text.isNotEmpty ? numberController.text : widget.number.toString(),
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