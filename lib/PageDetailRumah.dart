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

  Future<void> fetchDataDetailTipe() async {
    final response = await http.get(Uri.parse(
        'https://formsliving.com/api/getDetailRumah/${widget.index}'));
    if (response.statusCode == 200) {
      setState(() {
        _dataDetailTipe = Map<String, dynamic>.from(jsonDecode(response.body));
        hargaRumahController.text = _dataDetailTipe['harga_tr'].toString();

      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataDetailTipe();
    print('index tipe rumah : ${widget.index}');
  }

  void hitungSimulasiKPR() {
    // Fetch values from the TextEditingControllers
    double hargaRumah = double.parse(hargaRumahController.text);
    double uangMuka = double.parse(uangMukaController.text);
    double sukuBunga = double.parse(sukuBungaController.text);
    int jangkaWaktu = int.parse(jangkaWaktuController.text);
    _uangMukaToRupiah = (uangMuka/100) * hargaRumah;
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
                  children: [
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
                    if (_monthlyPayment > 0) // Show results only after calculation
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
                        icon: Icon(_isSidebarVisible ? Icons.close : Icons.menu),
                        onPressed: () {
                          setState(() {
                            _isSidebarVisible = !_isSidebarVisible;
                          });
                        },
                      ),
                      Text('Page Rumah'),
                      Text('Fetched Projek: ${_dataDetailTipe.toString()}'),
                    ],
                  ),
                  Text("Kamar:  ${_dataDetailTipe['kmr_mandi_tr']}"),
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
