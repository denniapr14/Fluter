import 'dart:convert';
import 'dart:math'; // Import the dart:math library
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import the intl package

class PageDetailRumah extends StatefulWidget {
  final int index;

  PageDetailRumah({required this.index});

  @override
  _PageDetailRumahState createState() => _PageDetailRumahState();
}

class _PageDetailRumahState extends State<PageDetailRumah> {
  final TextEditingController hargaRumahController =
      TextEditingController(text: '100000');
  final TextEditingController uangMukaController =
      TextEditingController(text: '10');
  final TextEditingController sukuBungaController =
      TextEditingController(text: '10');
  final TextEditingController jangkaWaktuController =
      TextEditingController(text: '10');
  bool _isSidebarVisible = true;
  Map<String, dynamic> _dataDetailTipe = {};
  double _monthlyPayment = 0.0; // State variable to store the monthly payment
  double _uangMukaAmount = 0.0;
  double _uangMukaToRupiah = 0.0;
  double _sukuBunga = 0.0;
  int _jangkaWaktu = 0;
  Map<String, String> specifications = {};
  @override
  void initState() {
    super.initState();
    fetchDataDetailTipe();
    print('index tipe rumah : ${widget.index}');
  }

  Future<void> fetchDataDetailTipe() async {
    final response = await http.get(Uri.parse(
        'https://formsliving.com/api/getDetailRumah/${widget.index}'));
    if (response.statusCode == 200) {
      setState(() {
        _dataDetailTipe = Map<String, dynamic>.from(jsonDecode(response.body));
        hargaRumahController.text = _dataDetailTipe['harga_tr'].toString();
        specifications = {
          "Pondasi": _dataDetailTipe['pondasi_tr'],
          "Struktur": _dataDetailTipe['struktur_tr'],
          "Dinding luar": _dataDetailTipe['dinding_dlm_tr'],
          "Dinding dalam": _dataDetailTipe['dinding_luar_tr'],
          "Dinding kamar mandi Utama": _dataDetailTipe['dinding_kmr_mnd_tr'],
          "Dinding meja Dapur": _dataDetailTipe['dd_meja_dapur_tr'],
          "Lantai Ruang Tidur": _dataDetailTipe['lt_ruang_tidur_tr'],
          "Lantai Ruang keluarga": _dataDetailTipe['lt_ruang_keluarga_tr'],
          "Lantai kamar mandi Utama": _dataDetailTipe['lt_kmr_mnd_utama_tr'],
          "Lantai Teras Utama": _dataDetailTipe['lt_teras_utama_tr'],
          "Rangka atap": _dataDetailTipe['rangka_atap_tr'],
          "Kusen": _dataDetailTipe['kusen_tr'],
          "Daun Pintu": _dataDetailTipe['daun_pintu_tr'],
          "Sanitary": _dataDetailTipe['sanitary_tr'],
          "Penutup atap": _dataDetailTipe['penutup_atap_tr'],
          "Plafon Dalam": _dataDetailTipe['plafon_dlm_tr'],
          "Handle": _dataDetailTipe['handle_tr'],
          "Lighting": _dataDetailTipe['lighting_tr'],
          "Daya Listrik": _dataDetailTipe['daya_listrik_tr'],
          "Carport": _dataDetailTipe['carport_tr'],
          "Tangga": _dataDetailTipe['tangga_tr']
        };
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void hitungSimulasiKPR() {
    // Fetch values from the TextEditingControllers
    double hargaRumah = double.parse(hargaRumahController.text);
    double uangMuka = double.parse(uangMukaController.text);
    double sukuBunga = double.parse(sukuBungaController.text);
    int jangkaWaktu = int.parse(jangkaWaktuController.text);
    _uangMukaToRupiah = (uangMuka / 100) * hargaRumah;
    // Simple calculation example
    double loanAmount = hargaRumah - uangMuka;
    double monthlyInterestRate = sukuBunga / 12 / 100;
    int numberOfPayments = jangkaWaktu * 12;

    double monthlyPayment = (loanAmount * monthlyInterestRate) /
        (1 - pow((1 + monthlyInterestRate), -numberOfPayments));

    // Update the state to reflect the calculated values
    setState(() {
      _monthlyPayment = monthlyPayment;
      _uangMukaAmount = uangMuka;
      _sukuBunga = sukuBunga;
      _jangkaWaktu = jangkaWaktu;
    });
  }

  String formatRupiah(double amount) {
    final NumberFormat formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isSidebarVisible ? 400 : 0,
              child: Visibility(
                visible: _isSidebarVisible,
                child: ListView(
                  children: 
                  [
                    
                    ListTile(
                      title: Text('Simulasi KPR'),
                    ),
                    TextField(
                      controller: hargaRumahController,
                      decoration: InputDecoration(
                        labelText: 'Harga Rumah',
                      ),
                      onChanged: (value) {},
                    ),
                    TextField(
                      controller: uangMukaController,
                      decoration: InputDecoration(
                        labelText: 'Uang Muka',
                      ),
                      onChanged: (value) {},
                    ),
                    TextField(
                      controller: sukuBungaController,
                      decoration: InputDecoration(
                        labelText: 'Suku Bunga',
                      ),
                      onChanged: (value) {},
                    ),
                    TextField(
                      controller: jangkaWaktuController,
                      decoration: InputDecoration(
                        labelText: 'Jangka Waktu',
                      ),
                      onChanged: (value) {},
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: hitungSimulasiKPR,
                      child: const Text("Hitung Simulasi KPR"),
                    ),
                    SizedBox(height: 20),
                    if (_monthlyPayment >
                        0) // Show results only after calculation
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hasil Simulasi',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'Uang Muka: ${_uangMukaAmount}% sejumlah ${formatRupiah(_uangMukaToRupiah)}'),
                          Text('Suku Bunga: $_sukuBunga%'),
                          Text('Jangka Waktu: $_jangkaWaktu Tahun'),
                          Text(
                            'Cicilan Bulanan: ${formatRupiah(_monthlyPayment)}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon:
                            Icon(_isSidebarVisible ? Icons.close : Icons.menu),
                        onPressed: () {
                          setState(() {
                            _isSidebarVisible = !_isSidebarVisible;
                          });
                        },
                      ),
                      Text("${_dataDetailTipe['nama_cluster'].toString()} / ${_dataDetailTipe['blok'].toString()} - ${_dataDetailTipe['nomor'].toString()}"),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        'https://d3p0bla3numw14.cloudfront.net/news-content/img/2022/05/29052121/Desain-Rumah-Perumahan-Type-36.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Text below the image
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tipe : ${_dataDetailTipe['jenis_tr'].toString()}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Icons for bath and room
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bathtub, size: 24.0),
                        Text(_dataDetailTipe['kmr_mandi_tr'].toString()),
                        SizedBox(width: 16.0),
                        Icon(Icons.bedroom_parent, size: 24.0),
                        Text(_dataDetailTipe['kmr_tidur_tr'].toString()),
                      ],
                    ),
                  ),
                  // Tabs for Denah, Spesifikasi
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.black,
                          tabs: [
                            Tab(text: 'Denah'),
                            Tab(text: 'Spesifikasi'),
                            Tab(text: 'Lainnya'),
                          ],
                        ),
                        Container(
                          height: 700.0, // Height of the TabBarView
                          child: TabBarView(
                            children: [
                              Center(child: Text('Denah Content')),
                              Center(
                                child: Table(
                                  border: TableBorder.all(
                                      color: Colors.transparent),
                                  children: specifications.entries.map((entry) {
                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            entry.key,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(entry.value),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                              Center(child: Text('Lainnya Content')),
                            ],
                          ),
                        ),
                      ],
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

void main() {
  runApp(PageDetailRumah(index: 1));
}
