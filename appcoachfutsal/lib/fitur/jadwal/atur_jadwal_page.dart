import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan ini

class AturJadwalPage extends StatefulWidget {
  const AturJadwalPage({Key? key}) : super(key: key);

  @override
  State<AturJadwalPage> createState() => _AturJadwalPageState();
}

class _AturJadwalPageState extends State<AturJadwalPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController lokasiController = TextEditingController();

  // Untuk update
  String? editingId;

  String get formattedDate =>
      selectedDate != null ? DateFormat('dd MMMM yyyy').format(selectedDate!) : 'Isi Tanggal';

  String get formattedTime =>
      selectedTime != null ? selectedTime!.format(context) : 'Isi waktu';

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  Future<void> _tambahAtauUpdateJadwal() async {
    if (selectedDate != null && selectedTime != null && lokasiController.text.isNotEmpty) {
      final jadwalData = {
        'tanggal': selectedDate,
        'jam': selectedTime!.format(context),
        'lokasi': lokasiController.text,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (editingId == null) {
        // Tambah
        await FirebaseFirestore.instance.collection('jadwal').add(jadwalData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil ditambahkan')),
        );
      } else {
        // Update
        await FirebaseFirestore.instance.collection('jadwal').doc(editingId).update(jadwalData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil diupdate')),
        );
        editingId = null;
      }

      setState(() {
        selectedDate = null;
        selectedTime = null;
        lokasiController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
    }
  }

  Future<void> _hapusJadwal(String id) async {
    await FirebaseFirestore.instance.collection('jadwal').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jadwal berhasil dihapus')),
    );
  }

  void _isiFormDariJadwal(DocumentSnapshot doc) {
    setState(() {
      editingId = doc.id;
      selectedDate = (doc['tanggal'] as Timestamp).toDate();
      // Jam disimpan sebagai string, parsing ke TimeOfDay
      final jamStr = doc['jam'] as String;
      final jamParts = jamStr.split(':');
      selectedTime = TimeOfDay(
        hour: int.parse(jamParts[0]),
        minute: int.parse(jamParts[1]),
      );
      lokasiController.text = doc['lokasi'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATUR JADWAL', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(formattedDate),
              ),
            ),
            const Text('Jam', style: TextStyle(fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(formattedTime),
              ),
            ),
            const Text('Tempat / Lokasi', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 32),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: lokasiController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  hintText: 'Masukkan Lokasi',
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _tambahAtauUpdateJadwal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(editingId == null ? 'Tambah Jadwal' : 'Update Jadwal', style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Daftar Jadwal', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('jadwal').orderBy('tanggal').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Terjadi error');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Text('Belum ada jadwal');
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final tanggal = (doc['tanggal'] as Timestamp).toDate();
                      final jam = doc['jam'];
                      final lokasi = doc['lokasi'];
                      return Card(
                        child: ListTile(
                          title: Text('${DateFormat('dd MMM yyyy').format(tanggal)} - $jam'),
                          subtitle: Text(lokasi),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _isiFormDariJadwal(doc),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _hapusJadwal(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}