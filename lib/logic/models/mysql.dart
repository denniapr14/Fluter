import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '192.168.18.4';
  static String user = 'root';
  static String password = '';
  static String db = 'one';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }

  void closeConnection(MySqlConnection conn) {
    conn.close();
  }
}