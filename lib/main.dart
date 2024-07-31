import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:formsliving/core.dart';
// import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'LandingPageWidget.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // // Make the app full screen and remove window buttons
  // doWhenWindowReady(() {
  //   final initialSize = Size(800, 600);
  //   appWindow.minSize = initialSize;
  //   appWindow.size = initialSize;
  //   appWindow.alignment = Alignment.center;
  //   appWindow.maximize();
  //   appWindow.hide();
  //   appWindow.title = 'Forms Living';
  //   // appWindow.minimize() = false;
  //   // appWindow.showSystemCursor = false;
  //   // appWindow.useCustomCursor = true;
  //   // appWindow.cursor = SystemMouseCursors.basic;
  //   // appWindow.fullScreen();
  // });
  //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      title: 'Forms Living',
      theme: ThemeData(
        primaryColor: AppColors.color1,
        // hintColor: AppColors.color2,
        // scaffoldBackgroundColor: AppColors.color3,
        textTheme: TextTheme(
            // bodyText1: TextStyle(color: AppColors.color4),
            // bodyText2: TextStyle(color: AppColors.color5),
            // headline1: TextStyle(color: AppColors.color6),
            ),
        appBarTheme: AppBarTheme(
          color: AppColors.color1,
        ),
        buttonTheme: ButtonThemeData(
          // buttonColor: AppColors.color2,
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
  static const Color ButtonBg = Color(0xFFC7EB57);
  static const Color TextButton = Color(0Xff1E130E);
  static const Color BgSlider = Color(0xFF686B5D);
   static const Color Slider = Color(0xffAAC067);
  static const Color TextColor = Color.fromARGB(255, 228, 228, 228);
  //  #AAC067,
  // #8B9669,
  //#C7EB57, (buttton)
  // #686B5D,
  // #3D4131,
  // #2E331E
}

class GlobalThemeData {
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(colorScheme: colorScheme, focusColor: focusColor);
  }
}
