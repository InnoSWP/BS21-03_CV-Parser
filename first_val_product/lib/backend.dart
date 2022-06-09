import 'dart:core';
import 'dart:io';

import 'package:read_pdf_text/read_pdf_text.dart';
import "package:file_picker/file_picker.dart";
import 'package:path_provider/path_provider.dart';

Future<File?> getCV() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'pdf', 'doc'],
  );
  if (result != null) {
    return File(result.files.single.path!);
  }
  return null;
}

Future<String?> pdfToString(File pdfFile) async {
  String text = "";
  try {
    text = await ReadPdfText.getPDFtext(pdfFile.path);
  } catch (err) {
    print(err);
    return null;
  }
  return text;
}

Future<String> stringToJson(String cvString) async {
  return await cvString;
}

FullCVInfo jsonToInfo(String json) {
  return FullCVInfo.fromJson(json);
}

Future exportCV(String jsonString, String fileName) async {
  Directory directory = await getApplicationDocumentsDirectory();
  File newFile = File("${directory.path}/$fileName.json");
  await newFile.writeAsString(jsonString);
}

class FullCVInfo {
  late String email;
  late String name;
  late List<CVInfoGroup> infoGroups;
  FullCVInfo.fromJson(String json) {
    email = "";
    name = "";
    infoGroups = [];
  }
}

class CVInfoGroup {
  late String name;
  late List<String> parameters;
  CVInfoGroup.fromJson(String json) {
    name = "";
    parameters = [];
  }
}
