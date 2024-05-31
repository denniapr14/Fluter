import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PageDetailRumah extends StatefulWidget {
  final int index;

  PageDetailRumah({required this.index});

  @override
  _PageDetailRumahState createState() => _PageDetailRumahState();
}

class _PageDetailRumahState extends State<PageDetailRumah> {
  bool _isSidebarVisible = true;
  Map<String, dynamic> _dataDetailTipe = {};

  Future<void> fetchDataDetailTipe() async {
    final response = await http.get(Uri.parse(
        'https://formsliving.com/api/getDetailRumah/${widget.index}'));
    if (response.statusCode == 200) {
      setState(() {
        _dataDetailTipe = Map<String, dynamic>.from(jsonDecode(response.body));
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
                      title: Text('Advanced Search'),
                    ),

                    // FOR CHECKING DATA

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: () {},
                      child: const Text("Search"),
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
                      Text('Fetched Projek: ${_dataDetailTipe.toString()}'),
                      
                    ],
                    
                  ),
                  
                  Text("Kamar:  ${_dataDetailTipe['kmr_mandi_tr']}")  ,
                // FutureBuilder(
                //   future: fetchDataDetailTipe(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return CircularProgressIndicator();
                //     } else if (snapshot.hasError) {
                //       return Text('Error: ${snapshot.error}');
                //     } else {
                //       return Column(
                //         children: [
                //           Text('Data loaded successfully'),
                //           Text('Kamar Mandi: ${_dataDetailTipe['kmr_mandi_tr']}'),
                //           Text('Kamar Tidur: ${_dataDetailTipe['kmr_tidur_tr']}'),
                //         ],
                //       );
                //     }
                //   },
                // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
