import 'package:flutter/material.dart';

class PagePenilaianPemain extends StatelessWidget {
  const PagePenilaianPemain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Ini yang bikin tombol back berfungsi
          },
        ),
        title: const Text(
          'PENILAIAN PEMAIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdownLabel("Posisi"),
              _buildDropdown(),
              _buildDropdownLabel("Nama Pemain"),
              _buildDropdown(),
              _buildDropdownLabel("Nama Aspek"),
              _buildDropdown(),
              const SizedBox(height: 8),
              const Divider(thickness: 1),
              const SizedBox(height: 8),
              const Text(
                "Aspek Pivot",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildAspekCard("Jumlah Gol", "Core Factor", Colors.orange),
                  const SizedBox(width: 16),
                  _buildAspekCard("Shooting", "Core Factor", Colors.orange),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildAspekCard("Ball Control", "Secondary Factor", Colors.blue),
                  const SizedBox(width: 16),
                  _buildAspekCard("Body Ballance", "Secondary Factor", Colors.blue),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        value: null,
        hint: const Text("Pilih Posisi"),
        items: [],
        onChanged: (value) {},
        icon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }

  Widget _buildAspekCard(String title, String factor, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              factor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.centerLeft,
            child: const Text("0"),
          )
        ],
      ),
    );
  }
}
