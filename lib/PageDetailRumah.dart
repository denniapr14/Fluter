import 'dart:convert';
import 'dart:math'; // Import the dart:math library
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import the intl package
import 'package:url_launcher/url_launcher.dart';
import 'package:formsliving/main.dart';

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
  List<Map<String, dynamic>> _listDataDenah = [];

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

  Future<void> _getDataDenah() async {
    try {
      final response = await http.get(Uri.parse(
          'https://formsliving.com/api/getDenah/detailTipeRumah/${widget.index}'));
      if (response.statusCode == 200) {
        setState(() {
          _listDataDenah =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
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
 void _launchURL() async {
    String url =
        'https://formsliving.com/simulation-detail-type/${_dataDetailTipe['id_tipe_rumah']}/${_dataDetailTipe['id_rumah']}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  void initState() {
    super.initState();
    fetchDataDetailTipe().then((_) {
      // Continue with the rest of the code here
      _getDataDenah();
      print(_listDataDenah);
      print('index tipe rumah : ${widget.index}');
    });
    _getDataDenah().then((_) {
      if (_listDataDenah.isNotEmpty) {
        // Continue with the rest of the code here
        print(_listDataDenah);
        print('index tipe rumah : ${widget.index}');
      } else {
        // Handle the case when _listDataDenah is empty
        // You can show an error message or take appropriate action
      }
    });
    print(_listDataDenah);
    print('index tipe rumah : ${widget.index}');
  }
  

  String formatRupiah(double amount) {
    final NumberFormat formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }
  
  double roundUpToThousands(double value) {
    return (value / 1000).ceil() * 1000;
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
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView(
                children: [
                  ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                    Navigator.pop(context);
                    },
                  ),
                  title: Text('Simulasi KPR'),
                  ),
                  SizedBox(height: 22),
                  TextField(
                  controller: hargaRumahController,
                  decoration: InputDecoration(
                    labelText: 'House Prices',
                  ),
                  onChanged: (value) {},
                  ),
                  SizedBox(height: 22),
                  TextField(
                  controller: uangMukaController,
                  decoration: InputDecoration(
                    labelText: 'Down payment',
                  ),
                  onChanged: (value) {},
                  ),
                  SizedBox(height: 22),
                  TextField(
                  controller: sukuBungaController,
                  decoration: InputDecoration(
                    labelText: 'Interest rate',
                  ),
                  onChanged: (value) {},
                  ),
                  SizedBox(height: 22),
                  TextField(
                  controller: jangkaWaktuController,
                  decoration: InputDecoration(
                    labelText: 'Time period',
                  ),
                  onChanged: (value) {},
                  ),
                  SizedBox(height: 22),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color5,
                      ),
                      onPressed: hitungSimulasiKPR,
                      child: const Text(
                      "Calculate KPR Simulation",
                      style: TextStyle(color: AppColors.color1),
                      ),
                    ),
                  SizedBox(height: 20),
                  if (_monthlyPayment > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      'Simulation Results',
                      style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 22),
                    Text(
                      'Down payment ${_uangMukaAmount}% a number ${formatRupiah(_uangMukaToRupiah)}'),
                    SizedBox(height: 22),
                    Text('Interest rate $_sukuBunga%'),
                    SizedBox(height: 22),
                    Text('Time period $_jangkaWaktu Years'),
                    SizedBox(height: 22),
                    Text(
                      'Monthly Installments ${formatRupiah(roundUpToThousands(_monthlyPayment))}',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ],
                  ),
                ],
                ),
              ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                              _isSidebarVisible ? Icons.close : Icons.menu),
                          onPressed: () {
                            setState(() {
                              _isSidebarVisible = !_isSidebarVisible;
                            });
                          },
                        ),
                        Text(
                            "${_dataDetailTipe['nama_cluster'].toString()} / ${_dataDetailTipe['blok'].toString()} - ${_dataDetailTipe['nomor'].toString()}"),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(16.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          'https://formsliving.com/Home/images/tipe/${_dataDetailTipe['img_tr']}',
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
                          Icon(Icons.bathtub, size: 40.0),
                            Text(' '+_dataDetailTipe['kmr_mandi_tr'].toString(), style: TextStyle(fontSize: 32.0,fontWeight: FontWeight.bold)),
                            SizedBox(width: 16.0),
                            Icon(Icons.bed, size: 40.0),
                            Text(' '+_dataDetailTipe['kmr_tidur_tr'].toString(), style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // Tabs for Denah, Spesifikasi
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Colors.white,
                            tabs: [
                              Tab(text: 'Floor plan'),
                              Tab(text: 'Specification'),
                            ],
                          ),
                          Container(
                            height: 900.0, // Height of the TabBarView
                            child: TabBarView(
                              children: [
                                Center(
                                    child: Container(
                                    padding: EdgeInsets.only(top: 40, left: 50, right: 50),
                                    child: ListView.builder(
                                      itemCount: _listDataDenah.length,
                                      itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(8.0),
                                        child: InteractiveViewer(
                                        child: Image.network(
                                          "https://formsliving.com/Home/images/denah/${_listDataDenah[index]['img_rumah']}",
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return Text('Image not found');
                                          },
                                        ),
                                        ),
                                      );
                                      },
                                    ),
                                    ),
                                 
                                ),
                                Center(
                                  child: Container(
                                  padding: EdgeInsets.only(top: 40, left: 50, right: 50),
                                  child: ListView(
                                  children: specifications.entries.map((entry) {
                                    return ListTile(
                                    title: Text(
                                      entry.key,
                                      style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(entry.value),
                                    );
                                  }).toList(),
                                  ),
                                  ),
                                ),
                                SizedBox(height: 22),
                                ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Container(
                        width: 300.0,
                        child: FloatingActionButton.extended(
                        onPressed: _launchURL,
                        label: Text(
                          "Buy Now!",
                          style: TextStyle(
                          color: AppColors.color1,
                          fontWeight: FontWeight.w900
                          ),
                        ),
                        backgroundColor: AppColors.color5,
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 
}

void main() {
  Map<String, dynamic> _dataDetailTipe = {}; // Define _dataDetailTipe variable
  runApp(PageDetailRumah(index: 1));
}
