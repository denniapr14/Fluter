import 'package:formsliving/logic/models/mysql.dart';
import 'package:mysql1/src/results/row.dart';

Future<List<Map<String, dynamic>>> fetchDataFromDatabase() async {
  final conn = await getConnection();
  final results = await conn.query('SELECT * FROM rumah');
  await conn.close();

  // Convert each ResultRow to a Map
  List<Map<String, dynamic>> dataList = [];
  for (var row in results) {
    Map<String, dynamic> rowData = {};
    row.forEach((key, value) {
      rowData[key] = value;
    } as void Function(dynamic element));
    dataList.add(rowData);
  }

  return dataList;
}
