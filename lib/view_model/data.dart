import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<Map<String, dynamic>?> loadData(String localPath) async {
  try {
    final directory =
        Directory((await getApplicationDocumentsDirectory()).path + localPath);
    if (directory.existsSync()) {
      String json = File(directory.path).readAsStringSync();
      final userMap = jsonDecode(json) as Map<String, dynamic>;
      return userMap;
    }
  } catch (e) {
    return null;
  }
  return null;
}

Future<String> saveData(String localPath, dynamic data) async {
  try {
    String json = jsonEncode(data);
    final directory = await getApplicationDocumentsDirectory();
    File(directory.path + localPath).writeAsString(json);
    return "";
  } catch (exception) {
    return exception.toString();
  }
}
