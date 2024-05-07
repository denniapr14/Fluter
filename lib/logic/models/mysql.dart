import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> getConnection() async {
  final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306, // Change it if your MySQL port is different
    user: 'root',
    password: '',
    db: 'u127_greenland',
  );

  return await MySqlConnection.connect(settings);
}
