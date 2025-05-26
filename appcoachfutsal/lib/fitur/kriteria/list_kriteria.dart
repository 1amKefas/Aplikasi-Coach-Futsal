import 'package:flutter/material.dart';
import 'package:appcoachfutsal/fitur/kriteria/add_kriteria_page.dart';

class DataKriteriaPage extends StatelessWidget {
  const DataKriteriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'KRITERIA PENILAIAN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4, // jumlah dummy kriteria
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nama Aspek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Icon(Icons.groups),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Persentase       40 %'),
                  const Text('Core Factor      60 %'),
                  const Text('Secondary Factor 40 %'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TambahKriteriaPage()));
        },
        icon: const Icon(Icons.add),
        label: const Text('New Kriteria'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
