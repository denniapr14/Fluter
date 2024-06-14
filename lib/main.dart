import 'package:flutter/material.dart';
import 'package:formsliving/core.dart';
import 'LandingPageWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forms Living',
      theme: ThemeData(
        primaryColor: AppColors.color1,
        hintColor: AppColors.color2,
        scaffoldBackgroundColor: AppColors.color3,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: AppColors.color4),
          bodyText2: TextStyle(color: AppColors.color5),
          headline1: TextStyle(color: AppColors.color6),
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.color1,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.color2,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: LandingPageWidget(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forms Living'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello, World!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppColors {
  static const Color color1 = Color(0xFF414037);
  static const Color color2 = Color(0xFFC0BA84);
  static const Color color3 = Color(0xFFEBDF7A);
  static const Color color4 = Color(0xFF6B6954);
  static const Color color5 = Color(0xFFFFEF5A);
  static const Color color6 = Color(0xFFFFEC31);
}
