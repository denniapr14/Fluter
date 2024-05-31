import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:formsliving/LandingPageWidget.dart';
import 'package:formsliving/PageDetailRumah.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Add this line

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
  List<String> _selectedProjek = [];

  @override
  bool _isSidebarVisible = true;
  bool _isExpanded = true;
  bool _isExpanded2 = false;
  int _sliderMulaiHarga = 0;
  int _sliderSelesaiHarga = 0; // Add this line
  int _sliderJmlKmrMandi = 0; // Add this line
  int _sliderJmlKmrTidur = 0; // Add this line
  int _sliderLuasBangunan = 0; // Add this line
  int _sliderLuasTanah = 0; // Add this line
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _listDataRumah = [];
  List<Map<String, dynamic>> _listDataRumah2 = [];
  List<Map<String, dynamic>> _listDataProjek = [];
  var _loadingCard = false;
  var kalmSelected = false;

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

  Future<void> _getDataProjek() async {
    try {
      final response =
          await http.get(Uri.parse('https://formsliving.com/api/getProjek'));
      if (response.statusCode == 200) {
        setState(() {
          _listDataProjek =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _searchRumah() async {
    final querySearchParameters = {
      if (_selectedProjek.isNotEmpty) 'projek[]': _selectedProjek,
      if (_sliderMulaiHarga != null) 'min_harga': _sliderMulaiHarga,
      if (_sliderSelesaiHarga != null) 'max_harga': _sliderSelesaiHarga,
      if (_sliderJmlKmrTidur != null) 'jml_kmr_tidur': _sliderJmlKmrTidur,
      if (_sliderJmlKmrMandi != null) 'jml_kmr_mandi': _sliderJmlKmrMandi,
      if (_sliderLuasTanah != null) 'luas_tanah': _sliderLuasTanah,
      if (_sliderLuasBangunan != null) 'luas_bangunan': _sliderLuasBangunan,
    };

    String url =
        'https://formsliving.com/api/searchRumah/advanced/$querySearchParameters';
    try {
      print('url: $url ');
      print('deni elek');
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _listDataRumah2 =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _getDataProjek();
    _selectedProjek.add(widget.option1);
  }

  String formatToRupiah(String number) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return formatter.format(int.parse(number));
  }

  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _listDataProjekCheckbox = [];
    for (var data in _listDataProjek) {
      _listDataProjekCheckbox.add({
        'nama_projek': data['nama_projek'],
        'checked': _selectedProjek.contains(data['nama_projek']),
      });
    }
    print(_listDataProjekCheckbox);
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
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                                      Text("Projek"),

                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            _listDataProjekCheckbox.length,
                                        itemBuilder: (context, index) {
                                          // print( "DataRumah : $_listDataRumah");
                                          return CheckboxListTile(
                                            title: Text(
                                                _listDataProjekCheckbox[index]
                                                    ['nama_projek']),
                                            value: _selectedProjek.contains(
                                                _listDataProjek[index]
                                                    ['nama_projek']),
                                            onChanged: (bool? value) {
                                              if (_listDataProjekCheckbox[index]
                                                      ['checked'] ==
                                                  false) {
                                                _selectedProjek.add(
                                                    _listDataProjekCheckbox[
                                                        index]['nama_projek']);
                                                _listDataProjekCheckbox[index]
                                                    ['checked'] = true;
                                              } else {
                                                _selectedProjek.remove(
                                                    _listDataProjekCheckbox[
                                                        index]['nama_projek']);
                                                _listDataProjekCheckbox[index]
                                                    ['checked'] = false;
                                              }
                                              print(_selectedProjek);
                                              setState(() {});
                                              OnSaved:
                                              (value) => _selectedProjek;
                                              print(
                                                  "Value Selected Projek $_selectedProjek");
                                            },
                                          );
                                        },
                                      ),

                                      // CheckboxListTile(
                                      //   title: Text('Kalm'),
                                      //   value: kalmSelected,
                                      //   onChanged: (bool? value) {
                                      //     if (kalmSelected == false) {
                                      //       kalmSelected = true;
                                      //     } else {
                                      //       kalmSelected = false;
                                      //     }
                                      //     setState(() {});
                                      //   },
                                      // ),
                                      Slider(
                                        value: _sliderMulaiHarga.toDouble(),
                                        min: 0,
                                        max: 100000000,
                                        onChanged: (double value) {
                                          setState(() {
                                            _sliderMulaiHarga = value.toInt();
                                          });
                                          OnSaved:
                                          (value) => _sliderMulaiHarga;
                                        },
                                      ),
                                      Text(
                                          'Harga Mulai: ${formatToRupiah(_sliderMulaiHarga.toString())}'),
                                      Slider(
                                        value: _sliderSelesaiHarga.toDouble(),
                                        min: 0,
                                        max: 100000000000,
                                        onChanged: (double value) {
                                          setState(() {
                                            _sliderSelesaiHarga = value.toInt();
                                          });
                                          OnSaved:
                                          (value) => _sliderSelesaiHarga;
                                        },
                                      ),
                                      Text(
                                          'Sampai Harga: ${formatToRupiah(_sliderSelesaiHarga.toString())}'),
                                      Slider(
                                        value: _sliderJmlKmrTidur.toDouble(),
                                        min: 0,
                                        max: 20,
                                        onChanged: (double value) {
                                          setState(() {
                                            _sliderJmlKmrTidur = value.toInt();
                                          });
                                          OnSaved:
                                          (value) => _sliderJmlKmrTidur;
                                        },
                                      ),
                                      Text(
                                          'Jumlah Kamar Tidur: $_sliderJmlKmrTidur'),
                                      Slider(
                                        value: _sliderJmlKmrMandi.toDouble(),
                                        min: 0,
                                        max: 20,
                                        onChanged: (double value) {
                                          setState(() {
                                            _sliderJmlKmrMandi = value.toInt();
                                          });
                                          OnSaved:
                                          (value) => _sliderJmlKmrMandi;
                                        },
                                      ),
                                      Text(
                                          'Jumlah Kamar Mandi: $_sliderJmlKmrMandi'),
                                      Slider(
                                        value: _sliderLuasTanah.toDouble(),
                                        min: 0,
                                        max: 500,
                                        onChanged: (double value) {
                                          setState(() {
                                            _sliderLuasTanah = value.toInt();
                                          });
                                          OnSaved:
                                          (value) => _sliderLuasTanah;
                                        },
                                      ),
                                      Text('Luas Tanah: $_sliderLuasTanah  m²'),
                                      Slider(
                                        value: _sliderLuasBangunan.toDouble(),
                                        min: 0,
                                        max: 500,
                                        onChanged: (double value) {
                                          setState(() {
                                            _sliderLuasBangunan = value.toInt();
                                          });
                                          OnSaved:
                                          (value) => _sliderLuasBangunan;
                                        },
                                      ),
                                      Text(
                                          'Luas Bangunan: $_sliderLuasBangunan  m²'),
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                              ),
                              onPressed: () {
                                _searchRumah();
                                _formKey.currentState!.save();
                                print(_listDataRumah2);
                              },
                              child: const Text("Search"),
                            ),
                          ],
                        )),
                    // FOR CHECKING DATA
                    // Text(
                    //   'Image URL: ${_listDataRumah[1]['img_tr']}',
                    // ),
                    // Text('Fetched Projek: ${_listDataProjek.toString()}'),
                    // Text('Fetched Data: ${_listDataRumah.toString()}'),
                    // Text('Option 1: ${widget.option1.toString()}'),
                    // Text('Option 2: ${widget.option2.toString()}'),
                    // Text('Option 3: ${widget.option3.toString()}'),
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
                                  builder: (context) => PageDetailRumah(
                                      index: data['id_tipe_rumah']),
                                ),
                              );
                            },
                            child: Card(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        // 'https://i0.wp.com/www.emporioarchitect.com/upload/portofolio/1280/desain-rumah-klasik-2-lantai-18180122-44542826230922123843.jpg'),
                                        "https://formsliving.com/Home/images/tipe/${data['img_tr']}"),
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
                                        '${data['nama_projek']}',
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
                                      color: Colors.black.withOpacity(0.5),
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
                                                '${data['kmr_mandi_tr']}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Icon(Icons.king_bed,
                                                  color: Colors.white),
                                              Text(
                                                '${data['kmr_tidur_tr']}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Harga: ${formatToRupiah(data['harga_tr'])}',
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            'Luas Bangunan: ${data['luas_bangunan_tr']} m²',
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            'Luas Tanah: ${data['luas_tanah']} m²',
                                            textAlign: TextAlign.left,
                                          ),
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
