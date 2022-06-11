import 'dart:core';
import 'dart:io';

import 'package:pdf_text/pdf_text.dart';
import "package:file_picker/file_picker.dart";
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String?> getCVString() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['pdf'], withData: true);
  if (result != null) {
    final PdfDocument document =
        PdfDocument(inputBytes: result.files.single.bytes);
    String text = PdfTextExtractor(document).extractText();
    document.dispose();
    return text;
  }
  return null;
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
