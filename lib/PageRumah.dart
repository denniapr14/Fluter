import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formsliving/LandingPageWidget.dart';
import 'package:formsliving/PageDetailRumah.dart';
import 'package:http/http.dart' as http;

class PageRumah extends StatefulWidget {
  final String option1;
  final String option2;
  final String option3;

  PageRumah({
    required this.option1,
    required this.option2,
    required this.option3,
  });
  @override
  State<PageRumah> createState() => _PageRumahState();
}

class _PageRumahState extends State<PageRumah> {
  bool _isSidebarVisible = true;
  bool _isExpanded = false;
  bool _isExpanded2 = false;
  int _sliderValue = 0; // Add this line
  int _sliderValue2 = 0; // Add this line
  int _sliderValue3 = 0; // Add this line
  int _sliderValue4 = 0; // Add this line
  int _sliderValue5 = 0; // Add this line
  List<Map<String, dynamic>> _listDataRumah = [];

  Future<void> fetchData() async {
    String url =
        'https://formsliving.com/api/getRumah/${widget.option1}/${widget.option2}/${widget.option3}';

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _listDataRumah =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle network or other errors
      // ...
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
                      title: Text('Advanced Search'),
                    ),

                    // FOR CHECKING DATA
                    Text('Fetched Data: ${_listDataRumah.toString()}'),
                    Text('Option 1: ${widget.option1.toString()}'),
                    Text('Option 2: ${widget.option2.toString()}'),
                    Text('Option 3: ${widget.option3.toString()}'),
                    ExpansionPanelList(
                      elevation: 0,
                      expandedHeaderPadding: EdgeInsets.zero,
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text('Basic Search'),
                            );
                          },
                          body: Column(
                            children: [
                              Slider(
                                value: _sliderValue.toDouble(),
                                min: 0,
                                max: 100,
                                onChanged: (double value) {
                                  setState(() {
                                    _sliderValue = value.toInt();
                                  });
                                },
                              ),
                              Text('Luas Tanah: $_sliderValue'),
                              Slider(
                                value: _sliderValue2.toDouble(),
                                min: 0,
                                max: 100,
                                onChanged: (double value) {
                                  setState(() {
                                    _sliderValue2 = value.toInt();
                                  });
                                },
                              ),
                              Text('Harga: $_sliderValue2'),
                              Slider(
                                value: _sliderValue3.toDouble(),
                                min: 0,
                                max: 100,
                                onChanged: (double value) {
                                  setState(() {
                                    _sliderValue3 = value.toInt();
                                  });
                                },
                              ),
                              Text('Jumlah Kamar Tidur: $_sliderValue3'),
                              Slider(
                                value: _sliderValue4.toDouble(),
                                min: 0,
                                max: 100,
                                onChanged: (double value) {
                                  setState(() {
                                    _sliderValue4 = value.toInt();
                                  });
                                },
                              ),
                              Text('Jumlah Kamar Mandi: $_sliderValue4'),
                              Slider(
                                value: _sliderValue5.toDouble(),
                                min: 0,
                                max: 100,
                                onChanged: (double value) {
                                  setState(() {
                                    _sliderValue5 = value.toInt();
                                  });
                                },
                              ),
                              Text('Luas Bangunan: $_sliderValue5'),
                            ],
                          ),
                          isExpanded: _isExpanded,
                        ),
                      ],
                    ),
                    ExpansionPanelList(
                      elevation: 0,
                      expandedHeaderPadding: EdgeInsets.zero,
                      expansionCallback: (int index, bool isExpanded2) {
                        setState(() {
                          _isExpanded2 = !_isExpanded2;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded2) {
                            return ListTile(
                              title: Text('Detail Rumah'),
                            );
                          },
                          body: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Pondasi',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Struktur',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Dinding Dalam',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Dinding Luar',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Dinding Kamar Mandi',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Meja Dapur',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Luas Ruang Tidur',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Luas Ruang Keluarga',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Luas Kamar Mandi Utama',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Luas Teras Utama',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Rangka Atap',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Penutup Atap',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Kusen',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Daun Pintu',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Sanitary',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Plafon Dalam',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Handle',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Lighting',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Daya Listrik',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Carport',
                                ),
                                onChanged: (value) {},
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Tangga',
                                ),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          isExpanded: _isExpanded2,
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
                      Text('Page Rumah'),
                    ],
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: List.generate(_listDataRumah.length, (index) {
                          var data = _listDataRumah[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PageDetailRumah(index: index + 1),
                                ),
                              );
                            },
                            child: Card(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/background.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      color: Colors.black.withOpacity(0.5),
                                      child: Text(
                                        'Header ${index + 1}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      padding: EdgeInsets.all(8),
                                      color: Colors.white.withOpacity(0.5),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Blok: ${data['blok']} - ${data['nomor']} / ${data['nama_cluster']}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.bathtub,
                                                  color: Colors.white),
                                              Text(
                                                'Bathroom',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Icon(Icons.king_bed,
                                                  color: Colors.white),
                                              Text(
                                                'Bedroom',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Blok: ${data['blok']} - ${data['nomor']}',
                                            textAlign: TextAlign.left,
                                          ),
                                          // Text(
                                          // 'Luas Bangunan: ${data.luasBangunan}',
                                          // textAlign: TextAlign.left,
                                          // ),
                                          // Text(
                                          // 'Lantai: ${data.lantai}',
                                          // textAlign: TextAlign.left,
                                          // ),
                                          // Text(
                                          // 'Projek: ${data.projek}', //database_nama
                                          // textAlign: TextAlign.left,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
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
