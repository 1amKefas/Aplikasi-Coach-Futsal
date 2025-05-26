import 'package:flutter/material.dart';
import 'package:appcoachfutsal/fitur/player/add_player_page.dart';
import 'package:appcoachfutsal/fitur/player/player_detail_page.dart'; // Tambahkan ini

class PlayerListPage extends StatelessWidget {
  const PlayerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final players = [
      {'name': 'Emi Martinez', 'position': 'KIPER', 'number': '1'},
      {'name': 'Rudiger', 'position': 'FLANK', 'number': '3'},
      {'name': 'Raphina', 'position': 'FLANK', 'number': '11'},
      {'name': 'Pedri', 'position': 'ANCHOR', 'number': '8'},
      {'name': 'Gavi', 'position': 'MIDFIELD', 'number': '10'},
      {'name': 'De Jong', 'position': 'MIDFIELD', 'number': '34'},
    ];

    Map<String, Color> positionColor = {
      'KIPER': Colors.orange,
      'FLANK': Colors.blue,
      'ANCHOR': Colors.pink,
      'MIDFIELD': Colors.green,
    };

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
      body: ListView.builder(
        itemCount: players.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final player = players[index];
          final color = positionColor[player['position']] ?? Colors.grey;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayerDetailPage(
                      name: player['name']!,
                      position: player['position']!,
                      number: int.parse(player['number']!), // parsing ke int
                      imageAsset: 'assets/images/profile.png', // tambahkan imageAsset
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              title: Text(player['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  player['position']!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              trailing: Text(
                player['number']!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPlayerPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Player'),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
