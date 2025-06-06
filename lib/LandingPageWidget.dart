import 'package:flutter/material.dart';
import 'package:formsliving/PageRumah.dart';
import 'package:formsliving/main.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LandingPageWidget extends StatefulWidget {
  @override
  _LandingPageWidgetState createState() => _LandingPageWidgetState();
}

class _LandingPageWidgetState extends State<LandingPageWidget>
    with TickerProviderStateMixin {
  String _selectedOption1 = 'Greenland';
  int _selectedOption2 = 100000000;
  int _selectedOption3 = 1000000000;
  List<int> optionValues2 = [100000000, 200000000, 400000000];
  List<int> optionValues3 = [1000000000, 2000000000, 5000000000];
  List<Map<String, dynamic>> _listData = [];
  late AnimationController _landingController;
  late AnimationController _landingControllerContainer;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _getData();
    _landingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _landingControllerContainer = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..forward();
    setFullScreen();
  }

  Future<void> _getData() async {
    try {
      final response =
          await http.get(Uri.parse('https://formsliving.com/api/getProjek'));
      if (response.statusCode == 200) {
        setState(() {
          _listData =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void setFullScreen() {
    if (isFullScreen == false) {
      isFullScreen = true;
    } else {
      isFullScreen = false;
    }
    setState(() {});
    FullScreenWindow.setFullScreen(isFullScreen);
  }

  void _sendDataToAPI() async {
    print("object");
    final url =
        'https://formsliving.com/api/getRumah/$_selectedOption1/$_selectedOption2/$_selectedOption3';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(_selectedOption1);
      print(_selectedOption2);
      print(_selectedOption3);
      print('test');
      // Navigate to the new page with selected options
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PageRumah(
            option1: _selectedOption1,
            option2: _selectedOption2.toString(),
            option3: _selectedOption3.toString(),
          ),
        ),
      );
    } else {
      // Handle error
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://images.pexels.com/photos/1261728/pexels-photo-1261728.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                  fit: BoxFit.cover,
                ),
              ),
              
              child: Scaffold(
                
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, -1),
                          end: Offset.zero,
                        ).animate(_landingController),
                        child: Text(
                          'Find Your Dream Home',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                        SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 1),
                          end: Offset.zero,
                        ).animate(_landingControllerContainer),
                        child: Container(
                          decoration: BoxDecoration(
                          color: AppColors.TextButton,
                          borderRadius: BorderRadius.circular(40),
                          ),
                          width: 700,
                          height: 60,
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                            value: _selectedOption1,
                            onChanged: (String? newValue) {
                              setState(() {
                              _selectedOption1 = newValue!;
                              });
                            },
                            dropdownColor: AppColors.TextButton,
                            items: _listData.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> data) {
                              return DropdownMenuItem<String>(
                              value: data['nama_projek'],
                              child: Text(
                                data['nama_projek'],
                                style: TextStyle(color: AppColors.TextColor),
                              ),
                              
                              );
                            }).toList(),
                            ),
                            SizedBox(width: 40),
                            DropdownButton<int>(
                            value: _selectedOption2,
                            onChanged: (int? newValue) {
                              setState(() {
                              _selectedOption2 = newValue!;
                              });
                            },
                            dropdownColor: AppColors.TextButton,
                            items: optionValues2
                              .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                '${value ~/ 1000000} jt',
                                style: TextStyle(color: AppColors.TextColor)
                              ),
                              );
                            }).toList(),
                            ),
                            SizedBox(width: 40),
                            DropdownButton<int>(
                            value: _selectedOption3,
                            onChanged: (int? newValue) {
                              setState(() {
                              _selectedOption3 = newValue!;
                              });
                            },
                            dropdownColor: AppColors.TextButton,
                            items: optionValues3
                              .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                              value: value,
                              child: Text('${value ~/ 1000000000} Milyar',style: TextStyle(color: AppColors.TextColor),
                              ),
                              
                              );
                            }).toList(),
                            ),
                            SizedBox(width: 40),
                            ElevatedButton(
                            onPressed: _sendDataToAPI,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.TextButton,
                              backgroundColor: AppColors.ButtonBg,
                            ),
                            child: Text('Search'),
                            ),
                          ],
                          ),
                        ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
              onPressed: () {
                // Handle button press
                setFullScreen();
              },
              child: Icon(Icons.fullscreen),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white, // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
