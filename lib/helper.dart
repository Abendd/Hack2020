import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  // For your reference print the AppDoc directory
  print(directory.path);
  return directory.path;
}

Future<File> localFile(String filename) async {
  final path = await _localPath;
  return File('$path/' + filename);
}

writeContent(filename, content) async {
  final file = await localFile(filename + '.json');
  // Write the file
  file.writeAsStringSync(json.encode(content));
}

readcontent(filename) async {
  final file = await localFile(filename + '.json');

  // Read the file
  var val = await file.readAsString();
  Map<String, dynamic> a = json.decode(val);
  return a;
}
