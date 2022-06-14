import 'dart:core';
import 'dart:io';

import "package:file_picker/file_picker.dart";
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart';
import 'dart:convert';

Future<FullCVInfo?> getCVInfo() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['pdf'], withData: true);
  if (result != null) {
    final PdfDocument document =
        PdfDocument(inputBytes: result.files.single.bytes);
    String text = PdfTextExtractor(document).extractText();
    document.dispose();
    text;
    return await FullCVInfo().fromCVString(text, result.files.single.name);
  }
  return null;
}

Future exportCV(String jsonString, String fileName) async {
  Directory directory = await getApplicationDocumentsDirectory();
  File newFile = File("${directory.path}/$fileName.json");
  await newFile.writeAsString(jsonString);
}

class FullCVInfo {
  late String fileName;
  late String cvString;
  late String json;
  late String name;
  late String coolText;
  late List<CVInfoGroup> infoGroups;
  CVInfoGroup? _getInfoGroup(String infoGroupName) {
    for (CVInfoGroup infoGroup in infoGroups) {
      if (infoGroup.name == infoGroupName) {
        return infoGroup;
      }
    }
    return null;
  }

  Future<FullCVInfo?> fromCVString(String cvString, String fileName) async {
    this.fileName = fileName;
    this.cvString = cvString;
    try {
      json = (await _cvStringToJson(cvString))!;
      jsonDecode(json);
      infoGroups = [];
      List<String> deserializedJson = json
          .replaceAll('[', "")
          .replaceAll(']', "")
          .replaceAll('{', "")
          .replaceAll("\\\\n", "")
          .replaceAll("\\\\t", "")
          .replaceAll("\\n", "")
          .replaceAll("\\r", "")
          .replaceAll("|", "")
          .split('}');
      for (var s in deserializedJson) {
        if (s == '') {
          continue;
        }
        List<String> splitParameter = s.split('"');
        String infoGroupName = splitParameter[7];
        String parameterName = splitParameter[3];
        //Uncomment those lines to preserve original names
        infoGroupName = infoGroupName.replaceAll('_', ' ').toLowerCase();
        parameterName = parameterName.replaceAll('_', ' ').toLowerCase();
        infoGroupName =
            infoGroupName.replaceRange(0, 1, infoGroupName[0].toUpperCase());
        parameterName =
            parameterName.replaceRange(0, 1, parameterName[0].toUpperCase());
        //Comment those lines to make them look cool
        CVInfoGroup? infoGroup = _getInfoGroup(infoGroupName);
        if (infoGroup == null) {
          infoGroups.add(CVInfoGroup(infoGroupName, [parameterName]));
        } else {
          infoGroup.parameters.add(parameterName);
        }
      }
      coolText = "";
      for (var infoGroup in infoGroups) {
        coolText += "${infoGroup.name}:\n";
        for (var parameter in infoGroup.parameters) {
          coolText += "    $parameter,\n";
        }
        coolText = coolText.replaceRange(
            coolText.length - 2, coolText.length - 1, ";");
      }
      return this;
    } catch (err) {
      print(err);
      return null;
    }
  }
}

class CVInfoGroup {
  late String name;
  late List<String> parameters;
  CVInfoGroup(this.name, this.parameters);
}

Future<String?> _cvStringToJson(String text) async {
  Response response = await post(
    Uri.parse('https://aqueous-anchorage-93443.herokuapp.com/CvParser'),
    headers: {
      "accept": "application/json",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    },
    body: jsonEncode({
      "text": text,
      "keywords": "string",
      "pattern": 11,
    }),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return null;
  }
}
