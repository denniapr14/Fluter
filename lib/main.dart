import 'package:flutter/material.dart';
import 'package:formsliving/halaman_rumah.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TESTING',
      home: HalamanRumah(),
    );
  }
}