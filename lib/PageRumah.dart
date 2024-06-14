import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:formsliving/LandingPageWidget.dart';
import 'package:formsliving/PageDetailRumah.dart';
import 'package:formsliving/main.dart';
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
  int _sliderSelesaiHarga = 100000000000; // Add this line
  int _sliderJmlKmrMandi = 0; // Add this line
  int _sliderJmlKmrTidur = 0; // Add this line
  int _sliderLuasBangunan = 0; // Add this line
  int _sliderLuasTanah = 0; // Add this line
  String _pondasiInput = "",
      _strukturInput = "",
      _dindingDalamInput = "",
      _dindingLuarInput = "",
      _dindingKamarMandiInput = "",
      _mejaDapurInput = "",
      _lantaiRuangTidurInput = "",
      _lantaiRuangKeluargaInput = "",
      _lantaiTerasUtamaInput = "",
      _rangkaAtapInput = "",
      _penutupAtapInput = "",
      _kusenInput = "",
      _daunPintuInput = "",
      _sanitaryInput = "",
      _plafonDalamInput = "",
      _handleInput = "",
      _lightingInput = "",
      _dayaListrikInput = "",
      _carportInput = "",
      _tanggaInput = "";
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
    final querySearchParameters = [];
    if (_selectedProjek.isNotEmpty) {
      querySearchParameters.add({'projek': _selectedProjek.toString()});
    }
    if (_sliderMulaiHarga != null) {
      querySearchParameters.add({'&min_harga': _sliderMulaiHarga});
    }
    if (_sliderSelesaiHarga != null) {
      querySearchParameters.add({'&max_harga': _sliderSelesaiHarga});
    }
    if (_sliderJmlKmrTidur != null && _sliderJmlKmrTidur != 0) {
      querySearchParameters.add({'&jml_kmr_tidur': _sliderJmlKmrTidur});
    }
    if (_sliderJmlKmrMandi != null && _sliderJmlKmrMandi != 0) {
      querySearchParameters.add({'&jml_kmr_mandi': _sliderJmlKmrMandi});
    }
    if (_sliderLuasTanah != null && _sliderLuasTanah != 0) {
      querySearchParameters.add({'&luas_tanah': _sliderLuasTanah});
    }
    if (_sliderLuasBangunan != null && _sliderLuasBangunan != 0) {
      querySearchParameters.add({'&luas_bangunan': _sliderLuasBangunan});
    }
    if (_pondasiInput.isNotEmpty) {
      querySearchParameters.add({'&pondasi': _pondasiInput});
    }
    if (_strukturInput.isNotEmpty) {
      querySearchParameters.add({'&struktur': _strukturInput});
    }
    if (_dindingDalamInput.isNotEmpty) {
      querySearchParameters.add({'&dinding_dalam': _dindingDalamInput});
    }
    if (_dindingLuarInput.isNotEmpty) {
      querySearchParameters
          .add({'&dinding_luar_kamar_mandi': _dindingLuarInput});
    }
    if (_dindingKamarMandiInput.isNotEmpty) {
      querySearchParameters
          .add({'&dinding_kmr_mnd_tr': _dindingKamarMandiInput});
    }
    if (_mejaDapurInput.isNotEmpty) {
      querySearchParameters.add({'&meja_dapur': _mejaDapurInput});
    }
    if (_lantaiRuangTidurInput.isNotEmpty) {
      querySearchParameters
          .add({'&lantai_ruang_tidur': _lantaiRuangTidurInput});
    }
    if (_lantaiRuangKeluargaInput.isNotEmpty) {
      querySearchParameters
          .add({'&lantai_ruang_keluarga': _lantaiRuangKeluargaInput});
    }
    if (_lantaiTerasUtamaInput.isNotEmpty) {
      querySearchParameters
          .add({'&lantai_teras_utama': _lantaiTerasUtamaInput});
    }
    if (_rangkaAtapInput.isNotEmpty) {
      querySearchParameters.add({'&rangka_atap': _rangkaAtapInput});
    }
    if (_penutupAtapInput.isNotEmpty) {
      querySearchParameters.add({'&penutup_atap': _penutupAtapInput});
    }
    if (_kusenInput.isNotEmpty) {
      querySearchParameters.add({'&kusen': _kusenInput});
    }
    if (_daunPintuInput.isNotEmpty) {
      querySearchParameters.add({'&daun_pintu': _daunPintuInput});
    }
    if (_sanitaryInput.isNotEmpty) {
      querySearchParameters.add({'&sanitary': _sanitaryInput});
    }
    if (_plafonDalamInput.isNotEmpty) {
      querySearchParameters.add({'&plafon_dalam': _plafonDalamInput});
    }
    if (_handleInput.isNotEmpty) {
      querySearchParameters.add({'&handle': _handleInput});
    }
    if (_lightingInput.isNotEmpty) {
      querySearchParameters.add({'&lighting': _lightingInput});
    }
    if (_dayaListrikInput.isNotEmpty) {
      querySearchParameters.add({'&daya_listrik': _dayaListrikInput});
    }
    if (_carportInput.isNotEmpty) {
      querySearchParameters.add({'&carport': _carportInput});
    }
    if (_tanggaInput.isNotEmpty) {
      querySearchParameters.add({'&tangga': _tanggaInput});
    }

    // [{projek: [Greenland]}, {min_harga: 0}, {max_harga: 0}, {jml_kmr_tidur: 0}, {jml_kmr_mandi: 0}, {luas_tanah: 0}, {luas_bangunan: 0}]
    String queryParameters = querySearchParameters.toString();
    queryParameters = queryParameters
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll(':', '=')
        .replaceAll(' ', '')
        .replaceAll(',', '');
    // ?projek=Greenland&min_harga=10000000&max_harga=2000000000000
    print('url: $queryParameters');
    String url =
        'https://formsliving.com/api/searchRumah/advanced/?$queryParameters';
    try {
      print('url: $url ');

      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _listDataRumah =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
        print('LIST DATA RUMAH 2 : ${_listDataRumah2.toString()}');
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

//   void _searchRumah() async {
//   final Map<String, dynamic> querySearchParameters = {};

//   if (_selectedProjek.isNotEmpty) {
//     querySearchParameters['projek'] = _selectedProjek.toString();
//   }
//   if (_sliderMulaiHarga != null) {
//     querySearchParameters['min_harga'] = _sliderMulaiHarga.toString();
//   }
//   if (_sliderSelesaiHarga != null) {
//     querySearchParameters['max_harga'] = _sliderSelesaiHarga.toString();
//   }
//   if (_sliderJmlKmrTidur != null && _sliderJmlKmrTidur != 0) {
//     querySearchParameters['jml_kmr_tidur'] = _sliderJmlKmrTidur.toString();
//   }
//   if (_sliderJmlKmrMandi != null && _sliderJmlKmrMandi != 0) {
//     querySearchParameters['jml_kmr_mandi'] = _sliderJmlKmrMandi.toString();
//   }
//   if (_sliderLuasTanah != null && _sliderLuasTanah != 0) {
//     querySearchParameters['luas_tanah'] = _sliderLuasTanah.toString();
//   }
//   if (_sliderLuasBangunan != null && _sliderLuasBangunan != 0) {
//     querySearchParameters['luas_bangunan'] = _sliderLuasBangunan.toString();
//   }

//   // Construct the query string
//   final queryString = Uri(queryParameters: querySearchParameters).query;

//   String url = 'https://formsliving.com/api/searchRumah/advanced/?$queryString';

//   try {
//     print('url: $url ');
//     http.Response response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         _listDataRumah2 =
//             List<Map<String, dynamic>>.from(jsonDecode(response.body));
//       });
//       print('LIST DATA RUMAH 2 : ${_listDataRumah2.toString()}');
//     } else {
//       throw Exception('Failed to load data');
//     }
//   } catch (e) {
//     print('Error fetching data: $e');
//   }
// }

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
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: Text(''),
                    ),

                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text("Project"),

                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: _listDataProjekCheckbox.length,
                              itemBuilder: (context, index) {
                                // print( "DataRumah : $_listDataRumah");
                                return CheckboxListTile(
                                  title: Text(_listDataProjekCheckbox[index]
                                      ['nama_projek']),
                                  value: _selectedProjek.contains(
                                      _listDataProjek[index]['nama_projek']),
                                  onChanged: (bool? value) {
                                    if (_listDataProjekCheckbox[index]
                                            ['checked'] ==
                                        false) {
                                      _selectedProjek.add(
                                          _listDataProjekCheckbox[index]
                                              ['nama_projek']);
                                      _listDataProjekCheckbox[index]
                                          ['checked'] = true;
                                    } else {
                                      _selectedProjek.remove(
                                          _listDataProjekCheckbox[index]
                                              ['nama_projek']);
                                      _listDataProjekCheckbox[index]
                                          ['checked'] = false;
                                    }
                                    print(_selectedProjek);
                                    setState(() {});
                                    OnSaved:
                                    (value) => _selectedProjek.toString();
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
                            Text(
                                'Starting Price: ${formatToRupiah(_sliderMulaiHarga.toString())}'),
                            Container(
                              width: 350,
                              child: Slider(
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
                            ),

                            SizedBox(height: 20),
                            Text(
                                'Up to Price: ${formatToRupiah(_sliderSelesaiHarga.toString())}'),
                            Container(
                              width: 350,
                              child: Slider(
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
                            ),
                            SizedBox(height: 20),
                            Text('Number of Bedrooms: $_sliderJmlKmrTidur'),
                            Container(
                              width: 350,
                              child: Slider(
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
                            ),
                            SizedBox(height: 20),
                            Text('Number of Bathrooms: $_sliderJmlKmrMandi'),
                            Container(
                              width: 350,
                              child: Slider(
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
                            ),
                            SizedBox(height: 20),
                            Text('Surface area: $_sliderLuasTanah  m²'),
                            Container(
                              width: 350,
                              child: Slider(
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
                            ),
                            SizedBox(height: 20),
                            Text('Building area: $_sliderLuasBangunan  m²'),
                            Container(
                              width: 350,
                              child: Slider(
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
                                      title: Text('Advanced Search'),
                                    );
                                  },
                                  body: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Column(
                                      children: [
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Pondasi',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Batu Kali'),
                                                value: 'Batu Kali'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _pondasiInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _pondasiInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Struktur',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Beton Bertulang'),
                                                value: 'Beton Bertulang'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _strukturInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _strukturInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Dinding Dalam',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Pasangan batu finishing cat'),
                                                value:
                                                    'Pasangan batu finishing cat'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _dindingDalamInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _dindingDalamInput =
                                                value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Dinding Luar',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Pasangan bata finishing cat'),
                                                value:
                                                    'Pasangan bata finishing cat'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _dindingLuarInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _dindingLuarInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Dinding Kamar Mandi',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Keramik'),
                                                value: 'Keramik'),
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Keramik (include tempat sabun tanam)'),
                                                value:
                                                    'Keramik (include tempat sabun tanam)'),
                                            DropdownMenuItem(
                                                child: Text('Keramik 40 x 40'),
                                                value: 'Keramik 40 x 40'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _dindingKamarMandiInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _dindingKamarMandiInput =
                                                value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Meja Dapur',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Keramik'),
                                                value: 'Keramik'),
                                            DropdownMenuItem(
                                                child:
                                                    Text('Granitile 60 x 60'),
                                                value: 'Granitile 60 x 60'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _mejaDapurInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _mejaDapurInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Lantai Ruang Tidur',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Granitile'),
                                                value: 'Granitile'),
                                            DropdownMenuItem(
                                                child:
                                                    Text('Granitile 60 x 60'),
                                                value: 'Granitile 60 x 60'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _lantaiRuangTidurInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _lantaiRuangTidurInput =
                                                value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Lantai Ruang Keluarga',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Granitile'),
                                                value: 'Granitile'),
                                            DropdownMenuItem(
                                                child:
                                                    Text('Granitile 60 x 60'),
                                                value: 'Granitile 60 x 60'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _lantaiRuangKeluargaInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _lantaiRuangKeluargaInput =
                                                value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText:
                                                'Dinding Kamar Mandi Utama',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Keramik'),
                                                value: 'Keramik'),
                                            DropdownMenuItem(
                                                child: Text('Keramik 40 x 40'),
                                                value: 'Keramik 40 x 40'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {},
                                          onSaved: (value) {
                                            _dindingKamarMandiInput =
                                                value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Lantai Teras Utama',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Granitile'),
                                                value: 'Granitile'),
                                            DropdownMenuItem(
                                                child: Text('Keramik 40 x 40'),
                                                value: 'Keramik 40 x 40'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _lantaiTerasUtamaInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _lantaiTerasUtamaInput =
                                                value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Rangka Atap',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Galvalum'),
                                                value: 'Galvalum'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _rangkaAtapInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _rangkaAtapInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Penutup Atap',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Genteng M-Class'),
                                                value: 'Genteng M-Class'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _penutupAtapInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _penutupAtapInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            labelText: 'Kusen',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Alumunium'),
                                                value: 'Alumunium'),
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Kayu Finishing Lazur'),
                                                value: 'Kayu Finishing Lazur'),
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Pintu Utama / Belakang Kusen Kayu Kamper / Ruang Lain Tanpa Kusen / Pintu Engsel Pivot',
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                value:
                                                    'Pintu Utama / Belakang Kusen Kayu Kamper / Ruang Lain Tanpa Kusen / Pintu Engsel Pivot'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _kusenInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _kusenInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            labelText: 'Daun Pintu',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Double Multiplek Finishing Lazur'),
                                                value:
                                                    'Double Multiplek Finishing Lazur'),
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Pintu dobel multiplek fin hpl (depan), Bingkai alumunium isi kaca (belakang)',
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                value:
                                                    'Pintu dobel multiplek fin hpl (depan), Bingkai alumunium isi kaca (belakang)'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _daunPintuInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _daunPintuInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            labelText: 'Sanitary',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Artisan - Counter top, Artisan - One piece closet, Artisan - Zink dan kran zink',
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                value:
                                                    'Artisan - Counter top, Artisan - One piece closet, Artisan - Zink dan kran zink'),
                                            DropdownMenuItem(
                                                child: Text(
                                                    'America Standard & Onda / Setara'),
                                                value:
                                                    'America Standard & Onda / Setara'),
                                            DropdownMenuItem(
                                                child: Text('Artisan (black)'),
                                                value: 'Artisan (black)'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _sanitaryInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _sanitaryInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Plafon Dalam',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Gypsum'),
                                                value: 'Gypsum'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _plafonDalamInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _plafonDalamInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Handle',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text('Artisan'),
                                                value: 'Artisan'),
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Artisan (Matte Black)'),
                                                value: 'Artisan (Matte Black)'),
                                            DropdownMenuItem(
                                                child: Text('ELT / Setara'),
                                                value: 'ELT / Setara'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _handleInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _handleInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Lighting',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child: Text(
                                                    'Direct dan Indirect Technique'),
                                                value:
                                                    'Direct dan Indirect Technique'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _lightingInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _lightingInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Daya Listrik',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child:
                                                    Text('1300 VA / 2200 VA'),
                                                value: '1300 VA / 2200 VA'),
                                            DropdownMenuItem(
                                                child: Text('2200 VA'),
                                                value: '2200 VA'),
                                            DropdownMenuItem(
                                                child: Text('1300 VA'),
                                                value: '1300 VA'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _dayaListrikInput =
                                                  value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _dayaListrikInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Carport',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child:
                                                    Text('White Coral stone'),
                                                value: 'White Coral stone'),
                                            DropdownMenuItem(
                                                child: Text('Ampyang'),
                                                value: 'Ampyang'),
                                            DropdownMenuItem(
                                                child:
                                                    Text('Multicolour stone'),
                                                value: 'Multicolour stone'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _carportInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _carportInput = value as String;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Tangga',
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                                child:
                                                    Text('Cor beton fin warna'),
                                                value: 'Cor beton fin warna'),
                                            // Add more options as needed
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _tanggaInput = value as String;
                                            });
                                          },
                                          onSaved: (value) {
                                            _tanggaInput = value as String;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  isExpanded: _isExpanded2,
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.color5,
                              ),
                              onPressed: () {
                                _searchRumah();
                                _formKey.currentState!.save();
                                print(_listDataRumah2);
                              },
                              child: const Text("Search",
                                  style: TextStyle(color: AppColors.color4)),
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
                      Text(''),
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
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
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
                                            '${data['blok']} - ${data['nomor']} / ${data['nama_cluster']} ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Tipe ${data['jenis_tr']}  ',
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
                                              Row(
                                                children: [
                                                  Icon(Icons.bathtub,
                                                      color: Colors.white),
                                                  SizedBox(
                                                      width:
                                                          4), // Space between icon and text
                                                  Text(
                                                    '${data['kmr_mandi_tr']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.bed,
                                                      color: Colors.white),
                                                  SizedBox(
                                                      width:
                                                          4), // Space between icon and text
                                                  Text(
                                                    '${data['kmr_tidur_tr']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.house,
                                                      color: Colors.white),
                                                  SizedBox(
                                                      width:
                                                          4), // Space between icon and text
                                                  Text(
                                                    '${data['luas_bangunan_tr']} m²',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.terrain,
                                                      color: Colors.white),
                                                  SizedBox(
                                                      width:
                                                          4), // Space between icon and text
                                                  Text(
                                                    '${data['luas_tanah']} m²',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Harga ${formatToRupiah(data['harga_tr'])}',
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
