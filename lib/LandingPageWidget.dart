import 'package:flutter/material.dart';

class LandingPageWidget extends StatefulWidget {
  @override
  _LandingPageWidgetState createState() => _LandingPageWidgetState();
}

class _LandingPageWidgetState extends State<LandingPageWidget> {
  String _selectedOption1 = 'Greenland';
  String _selectedOption2 = '100 jt';
  String _selectedOption3 = '1 Milyar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Set background color to dark grey
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Find Fast What You Need',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                    items: <String>['Greenland', 'Kalm', 'Joyo Grand']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    
                  ),
                  SizedBox(width: 40),
                  DropdownButton<String>(
                    value: _selectedOption2,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption2 = newValue!;
                      });
                    },
                    items: <String>['100 jt', '200 jt', '400 jt']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    
                  ),
                  SizedBox(width: 40),
                  DropdownButton<String>(
                    value: _selectedOption3,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption3 = newValue!;
                      });
                    },
                    items: <String>['1 Milyar', '2 Milyar', '4 Milyar']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    
                  ),
                  SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      // Add button press logic here
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: Text('Search'),
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
