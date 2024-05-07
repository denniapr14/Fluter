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
      title: 'Flutter MySQL Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        title: Text('Flutter MySQL Test'),
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

//   // Update some data
//   // await conn.query('update users set age=? where name=?', [26, 'Bob']);

//   // Query again database using a parameterized query

//   // Finally, close the connection
//   await conn.close();
// }
// import 'package:flutter/material.dart';
// import 'package:formsliving/halaman_rumah.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'TESTING',
//       home: HalamanRumah(),
//     );
//   }
// }
