import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class StatistikPemainPage extends StatefulWidget {
  @override
  _StatistikPemainPageState createState() => _StatistikPemainPageState();
}

class _StatistikPemainPageState extends State<StatistikPemainPage> {
  String? selectedPosition;
  String? selectedPlayer;
  String? selectedDate;
  
  
  // Controllers untuk berbagai statistik pemain
  Map<String, TextEditingController> controllers = {};
  
  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controllers untuk semua field input
    final List<String> allFields = [
      // Aspek Fisik
      'endurance', 'strength', 'weight', 'height',
      
      // Aspek Defence
      'bodyBalance', 'intersepi', 'aggression', 'composure',
      
      // Aspek Attack
      'finishing', 'shooting', 'ballControl', 'crossing',
      
      // Aspek Tactical
      'jumlahGol', 'shootingTactical', 'ballControlTactical', 'bodyBalanceTactical',
      
      // Aspek Emotional
      'kedisiplinan', 'motivasi', 'teamwork', 'kontrolEmosi',
    ];
    
    for (var field in allFields) {
      controllers[field] = TextEditingController(text: '0');
    }
  }
  
  @override
  void dispose() {
    // Dispose semua controllers saat halaman dihapus
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan tombol kembali
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.grey),
                      onPressed: () {
                        // Navigasi kembali
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      'STATISTIK PEMAIN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
                // Posisi
                Text('Posisi', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedPosition,
                    decoration: InputDecoration(
                      hintText: 'Pilih Posisi',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: ['Pivot', 'Flank', 'Anchor', 'Goalkeeper']
                        .map((String position) {
                      return DropdownMenuItem<String>(
                        value: position,
                        child: Text(position),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPosition = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                
                // Nama Pemain
                Text('Nama Pemain', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedPlayer,
                    decoration: InputDecoration(
                      hintText: 'Pilih Pemain',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: ['Jay Idzes', 'Tom Haye', 'Rizky Ridho', 'Marselino', 'Nathan Tjoe']
                        .map((String player) {
                      return DropdownMenuItem<String>(
                        value: player,
                        child: Text(player),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPlayer = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                
                // Tab untuk melihat berbagai jenis tampilan statistik
                TabBar(
                  tabs: [
                    Tab(text: 'Input Statistik'),
                    Tab(text: 'Detail Attack'),
                    Tab(text: 'Detail Defence'),
                  ],
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                ),
                
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tab 1: Input Statistik (Semua aspek)
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            
                            // Aspek Fisik
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              child: Text(
                                'Aspek Fisik',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            
                            // Grid layout untuk aspek fisik
                            statisticGrid([
                              {'label': 'Endurance', 'controller': controllers['endurance']!},
                              {'label': 'Strenght', 'controller': controllers['strength']!},
                              {'label': 'Weight', 'controller': controllers['weight']!},
                              {'label': 'Height', 'controller': controllers['height']!},
                            ]),
                            
                            SizedBox(height: 16),
                            
                            // Aspek Defence
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              child: Text(
                                'Aspek Defence',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            
                            // Grid layout untuk aspek defence
                            statisticGrid([
                              {'label': 'Body Balance', 'controller': controllers['bodyBalance']!},
                              {'label': 'Intersepi', 'controller': controllers['intersepi']!},
                              {'label': 'Aggression', 'controller': controllers['aggression']!},
                              {'label': 'Composure', 'controller': controllers['composure']!},
                            ]),
                            
                            SizedBox(height: 16),
                            
                            // Aspek Attack
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              child: Text(
                                'Aspek Attack',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            
                            // Grid layout untuk aspek attack
                            statisticGrid([
                              {'label': 'Finishing', 'controller': controllers['finishing']!},
                              {'label': 'Shooting', 'controller': controllers['shooting']!},
                              {'label': 'Ball Control', 'controller': controllers['ballControl']!},
                              {'label': 'Crossing', 'controller': controllers['crossing']!},
                            ]),
                            
                            SizedBox(height: 16),
                            
                            // Aspek Tactical
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              child: Text(
                                'Aspek Tactical',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            
                            // Grid layout untuk aspek tactical
                            statisticGrid([
                              {'label': 'Jumlah Gol', 'controller': controllers['jumlahGol']!},
                              {'label': 'Shooting', 'controller': controllers['shootingTactical']!},
                              {'label': 'Ball Control', 'controller': controllers['ballControlTactical']!},
                              {'label': 'Body Balance', 'controller': controllers['bodyBalanceTactical']!},
                            ]),
                            
                            SizedBox(height: 16),
                            
                            // Aspek Emotional
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              child: Text(
                                'Aspek Emotional',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            
                            // Grid layout untuk aspek emotional
                            statisticGrid([
                              {'label': 'Kedisiplinan', 'controller': controllers['kedisiplinan']!},
                              {'label': 'Motivasi & Semangat', 'controller': controllers['motivasi']!},
                              {'label': 'Teamwork', 'controller': controllers['teamwork']!},
                              {'label': 'Kontrol Emosi', 'controller': controllers['kontrolEmosi']!},
                            ]),
                            
                            SizedBox(height: 24),
                            
                            // Tombol Submit
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Simpan statistik
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Statistik berhasil disimpan')),
                                  );
                                  
                                  // Opsional: Navigate back or to result page
                                  // Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Submit Penilaian',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                      
                      // Tab 2: Detail Attack
                      detailStatistikView("Attack"),
                      
                      // Tab 3: Detail Defence
                      detailStatistikView("Defence"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Helper widget untuk membuat grid statistik
  Widget statisticGrid(List<Map<String, dynamic>> items) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      children: items.map((item) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['label']),
            SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: item['controller'],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
  
  // Helper widget untuk membuat tampilan detail statistik
  Widget detailStatistikView(String category) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          
          // Detail Statistik Pemain
          Center(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'Detail Statistik Pemain',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Dropdown untuk memilih pertandingan berdasarkan tanggal
          Container(
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedDate,
              decoration: InputDecoration(
                hintText: 'Pertandingan Tanggal 28 Juli 2024',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              icon: Icon(Icons.keyboard_arrow_down),
              items: ['Pertandingan Tanggal 28 Juli 2024', 'Pertandingan Tanggal 20 Juli 2024']
                  .map((String date) {
                return DropdownMenuItem<String>(
                  value: date,
                  child: Text(date),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDate = newValue;
                });
              },
            ),
          ),
          
          SizedBox(height: 24),
          
          // Header untuk kategori (Attack, Defence, dll)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                category,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // List statistik untuk kategori yang dipilih
          buildStatisticList('Jumlah Gol', '4'),
          buildStatisticList('Shooting', '4'),
          buildStatisticList('Acceleration', '4'),
          buildStatisticList('Crossing', '4'),
          
          SizedBox(height: 24),
          
          // Defence section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                'Defence',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          buildStatisticList('Jumlah Gol', '4'),
          buildStatisticList('Shooting', '4'),
          buildStatisticList('Acceleration', '4'),
          buildStatisticList('Crossing', '4'),
          
          SizedBox(height: 24),
          
          // Tactical section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                'Tactical',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          buildStatisticList('Jumlah Gol', '4'),
          buildStatisticList('Shooting', '4'),
          buildStatisticList('Acceleration', '4'),
          buildStatisticList('Crossing', '4'),
          
          SizedBox(height: 24),
          
          // Emotional section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                'Emotional',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          buildStatisticList('Jumlah Gol', '4'),
          buildStatisticList('Shooting', '4'),
          buildStatisticList('Acceleration', '4'),
          buildStatisticList('Crossing', '4'),
          
          SizedBox(height: 24),
        ],
      ),
    );
  }
  
  Widget radarChartWidget(List<String> labels, List<double> values) {
    return SizedBox(
      height: 250,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          titleTextStyle: const TextStyle(fontSize: 12),
          getTitle: (index, _) {
            return RadarChartTitle(text: labels[index % labels.length]);
          },
          dataSets: [
            RadarDataSet(
              fillColor: Colors.blue.withOpacity(0.3),
              borderColor: Colors.blue,
              entryRadius: 3,
              dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  

  // Helper widget untuk menampilkan baris statistik individual
  Widget buildStatisticList(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// Contoh penggunaan untuk dimasukkan ke dalam aplikasi yang sudah ada
class StatistikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Statistik Pemain Futsal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StatistikPemainPage(),
    );
  }
}

void main() {
  runApp(StatistikApp());
}

