import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

class HalamanRumah extends StatefulWidget {
  const HalamanRumah({Key? key}) : super(key: key);

  @override
  State<HalamanRumah> createState() => _HalamanRumahState();
}

class _HalamanRumahState extends State<HalamanRumah> {
  List<Map<String, dynamic>> _listData = [];
  bool _loading = true;

  Future<void> _getData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8000/api/getRumah'));
      if (response.statusCode == 200) {
        setState(() {
          _listData =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
          _loading = false;
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
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blueGrey,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listData.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_listData[index]['nama_cluster'] +
                        '/' +
                        _listData[index]['blok'] +
                        " - " +
                        _listData[index]['nomor']),
                    subtitle: Text(_listData[index]['status_stock']),
                  ),
                );
              })),
    );
  }
}
