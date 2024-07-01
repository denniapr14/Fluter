import 'dart:convert';
import 'dart:math'; // Import the dart:math library
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class _PageDetailRumahState extends State<PageDetailRumah>
    with TickerProviderStateMixin {
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
  late AnimationController _AnimationController;

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
        'https://formsliving.com/simulation-detail-type/${_dataDetailTipe['id_rumah']}/${_dataDetailTipe['id_tipe_rumah']}';
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

    _AnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
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

 String formatToRupiah(String number) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return formatter.format(int.parse(number));
  }
  double roundUpToThousands(double value) {
    return (value / 1000).ceil() * 1000;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 30,
              )),
          title: (_dataDetailTipe['nama_cluster'] ==null)?CircularProgressIndicator() : Text(
              "${_dataDetailTipe['blok']} - ${_dataDetailTipe['nomor']} / ${_dataDetailTipe['nama_cluster']}"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
          ],
        ),
        body:  Row(
          children: [
            AnimatedContainer(
              decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppColors.BgSlider,  // Customize the color here
                      width: 2,             // Customize the width here
                    ),
                  ),
                ),
              duration: const Duration(milliseconds: 200),
              width: _isSidebarVisible ? 400 : 72,
              child: Visibility(
                child: ListView(
                  // visible: _isSidebarVisible,
                  children: [
                    ListTile(
                      leading: IconButton(
                        icon: _isSidebarVisible
                            ? ImageIcon(
                                AssetImage('assets/icon/shrinksidebar256.png'),
                                size: 24.0,
                              )
                            : Icon(Icons.menu),
                        onPressed: () {
                          setState(() {
                            _isSidebarVisible = !_isSidebarVisible;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: _isSidebarVisible,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Simulation KPR',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.0),
                             (_dataDetailTipe['harga_tr'] ==null)?CircularProgressIndicator() : 
                            Container(
                              width: 160,
                              child: TextField(
                                controller: hargaRumahController,
                                decoration: InputDecoration(
                                  labelText: 'Price',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Container(
                              width: 120, 
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  TextField(
                                    controller: uangMukaController,
                                    decoration: InputDecoration(
                                      labelText: 'Down Payment (%)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  TextField(
                                    controller: sukuBungaController,
                                    decoration: InputDecoration(
                                      labelText: 'Interest (%)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  TextField(
                                    controller: jangkaWaktuController,
                                    decoration: InputDecoration(
                                      labelText: 'Time period (Year)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.ButtonBg,
                                ),
                              onPressed: () {
                              hitungSimulasiKPR();
                              },
                              child: Text(
                              'Calculate',
                              style: TextStyle(color: AppColors.TextButton),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_monthlyPayment > 0)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Simulation Results',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                            'Down payment ${_uangMukaAmount}% a number ${formatRupiah(_uangMukaToRupiah)}'),
                                        SizedBox(height: 8),
                                        Text('Interest $_sukuBunga%'),
                                        SizedBox(height: 8),
                                        Text('Time period $_jangkaWaktu Years'),
                                        SizedBox(height: 8),
                                        Text(
                                          'Monthly Installments ${formatRupiah(roundUpToThousands(_monthlyPayment))}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [  (_dataDetailTipe['img_tr'] ==null)?CircularProgressIndicator() :
                    Container(
                      width: 700,
                      margin: EdgeInsets.all(16.0),
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child:   Image.network(
                          'https://formsliving.com/Home/images/tipe/${_dataDetailTipe['img_tr']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Text below the image
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: 
                                 (_dataDetailTipe['jenis_tr'] ==null)?CircularProgressIndicator() :
                                Text(
                                  'Tipe ${_dataDetailTipe['jenis_tr'].toString()}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.bathtub, size: 24.0),
                                   (_dataDetailTipe['kmr_mandi_tr'] ==null)?CircularProgressIndicator() :
                                  Text(
                                      ' ' +
                                          _dataDetailTipe['kmr_mandi_tr']
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 16.0),
                                  Icon(Icons.bed, size: 24.0),
                                  (_dataDetailTipe['kmr_tidur_tr'] ==null)?CircularProgressIndicator() :
                                  Text(
                                      ' ' +
                                          _dataDetailTipe['kmr_tidur_tr']
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),

                          // Icons for bath and room
                          Spacer(),
                          (_dataDetailTipe['harga_tr'] ==null)?CircularProgressIndicator() : 
                            Padding(
                              padding: EdgeInsets.only(right: 42),
                              child: Text(formatToRupiah(_dataDetailTipe['harga_tr'])),
                            ),
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
                                    padding: EdgeInsets.only(
                                        top: 40, left: 50, right: 50),
                                    child: ListView.builder(
                                      itemCount: _listDataDenah.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.all(8.0),
                                          child: InteractiveViewer(
                                            child:  (_dataDetailTipe['img_rumah'] ==null)? const CircularProgressIndicator() : 
                                            Image.network(
                                              "https://formsliving.com/Home/images/denah/${_listDataDenah[index]['img_rumah']}",
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
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
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(_AnimationController),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 40, left: 50, right: 50),
                                      child: ListView(
                                        children:
                                            specifications.entries.map((entry) {
                                          return ListTile(
                                            title: Text(
                                              '${entry.key} : ${entry.value}',
                                              style: TextStyle(),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )
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
                                  color: AppColors.TextButton,
                                  fontWeight: FontWeight.w900),
                            ),
                            backgroundColor: AppColors.ButtonBg,
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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 5), () {
      Navigator.pop(context); //pop dialog
    });
  }
}

void main() {
  Map<String, dynamic> _dataDetailTipe = {}; // Define _dataDetailTipe variable
  runApp(PageDetailRumah(index: 1));
}
