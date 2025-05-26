import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AturJadwalPage extends StatefulWidget {
  const AturJadwalPage({Key? key}) : super(key: key);

  @override
  State<AturJadwalPage> createState() => _AturJadwalPageState();
}

class _AturJadwalPageState extends State<AturJadwalPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController lokasiController = TextEditingController();

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

  void _tambahJadwal() {
    if (selectedDate != null && selectedTime != null && lokasiController.text.isNotEmpty) {
      // Tambahkan ke database atau simpan data di sini
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jadwal berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
    }
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
                onPressed: _tambahJadwal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Tambah  Jadwal', style: TextStyle(color: Colors.white),),  
              ),
            )
          ],
        ),
      ),
    );
  }
}
