import 'dart:core';
import 'dart:io';

import "package:file_picker/file_picker.dart";
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_file_saver/flutter_file_saver.dart';

class CVInfoGroup {
  late List<String> keywords;
  late String name;
  late List<String> parameters;
  CVInfoGroup(this.name, this.keywords, this.parameters);
}

class CVInfo {
  late String fileName;
  late String cvString;
  late String json;
  late String applicantsName;
  late String? applicantsEmail;
  late String coolText;
  late List<CVInfoGroup> infoGroups;
  CVInfo(this.cvString, this.fileName, this.infoGroups) {
    applicantsName = cvString.split('\n')[1];
    applicantsEmail = infoGroups[0].parameters.firstWhere(
        (element) =>
            element.contains("@") &&
            element.indexOf('@') - 1 > 0 &&
            element[element.indexOf('@') - 1] != ' ',
        orElse: () => "No email found");
    coolText = "";
    json = "[\n";
    for (var infoGroup in infoGroups) {
      coolText += "${infoGroup.name}:\n";
      json +=
          '\t{\n\t\t"groupName":"${infoGroup.name}",\n\t\t"parameters":\n\t\t[\n';
      for (var parameter in infoGroup.parameters) {
        coolText += "    $parameter,\n";
        json += '\t\t\t"$parameter",\n';
      }
      coolText =
          coolText.replaceRange(coolText.length - 2, coolText.length - 1, ";");
      json =
          json.replaceRange(json.length - 2, json.length - 1, "\n\t\t]\n\t},");
    }
    json = json.replaceRange(json.length - 2, json.length - 1, '\n]');
  }
  CVInfoGroup? _getInfoGroup(String infoGroupName) {
    for (CVInfoGroup infoGroup in infoGroups) {
      if (infoGroup.name == infoGroupName) {
        return infoGroup;
      }
    }
    return null;
  }

  Future export({String? postfix}) async {
    postfix ??= "";
    Directory directory = await getApplicationDocumentsDirectory();
    File newFile = File(
        "${directory.path}\\${fileName.replaceRange(fileName.length - 4, fileName.length, "")}$postfix.json");
    await newFile.writeAsString(json);
  }

  bool searchFor(String searchString) {
    return cvString.toLowerCase().contains(searchString.toLowerCase());
  }
}

Future<List<CVInfoGroup>?> _infoGroupsWithAPI(String text) async {
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
  String json;
  if (response.statusCode == 200) {
    json = response.body;
  } else {
    return null;
  }
  List<CVInfoGroup> r = [];
  List<String> deserializedJson = json
      .replaceAll('[', "")
      .replaceAll(']', "")
      .replaceAll('{', "")
      .replaceAll("\\\\n", "")
      .replaceAll("\\\\t", "")
      .replaceAll("\\t", "")
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
    //Comment those lines to make the names look cool
    CVInfoGroup? infoGroup;
    if (r.any((element) => element.name == infoGroupName)) {
      infoGroup = r.firstWhere((element) => element.name == infoGroupName);
      if (!infoGroup.parameters.contains(parameterName)) {
        infoGroup.parameters.add(parameterName);
      }
    } else {
      r.add(CVInfoGroup(infoGroupName, [], [parameterName]));
    }
  }
}

List<CVInfoGroup> _infoGroupsWithoutAPI(String text) {
  List<String> splitStrings = text
      .replaceRange(text.length - 1, text.length, '')
      .replaceRange(0, 1, '')
      .replaceAll("\\\\n", "")
      .replaceAll("\\\\t", "")
      .replaceAll("\\t", "")
      .replaceAll("\\r", "")
      .split('\\n');
  {
    List<String> temp = [];
    for (var element in splitStrings) {
      temp.addAll(element.split('\n'));
    }
    splitStrings = temp;
  }
  {
    List<String> temp = [];
    for (var element in splitStrings) {
      temp.addAll(element.split('\r'));
    }
    splitStrings = temp;
  }
  {
    List<String> temp = [];
    for (var element in splitStrings) {
      temp.addAll(element.split('\r\n'));
    }
    splitStrings = temp;
  }
  List<String> personalInfo = [splitStrings[1]];
  personalInfo.addAll(splitStrings[2].split(" | "));
  CVInfoGroup personal = CVInfoGroup("Personal", [], personalInfo);
  CVInfoGroup technicalSkills =
      CVInfoGroup("Technical Skills", ["Technical"], []);
  CVInfoGroup softSkills = CVInfoGroup("Soft Skills", ["Soft skills"], []);
  CVInfoGroup languages = CVInfoGroup("Languages", ["Languages"], []);
  CVInfoGroup education = CVInfoGroup("Education", [], []);
  CVInfoGroup instructingExperience =
      CVInfoGroup("Instructing Experience", [], []);
  CVInfoGroup professionalExperience =
      CVInfoGroup("Professional Experience", [], []);
  CVInfoGroup practicalExperience = CVInfoGroup("Practical Experience", [], []);
  List<CVInfoGroup> infoGroups = [
    personal,
    technicalSkills,
    softSkills,
    languages,
    education,
    instructingExperience,
    practicalExperience
  ];
  Map<String, CVInfoGroup?> keywordToGroupMap = {
    "SKILLS": null,
    "EDUCATION": education,
    "PROFESSIONAL EXPERIENCE": professionalExperience,
    "INSTRUCTING EXPERIENCE": instructingExperience,
    "PROJECT": practicalExperience,
    "DEVELOPMENT": practicalExperience
  };
  CVInfoGroup? currentInfoGroup;
  splitStrings.removeWhere((element) => element.replaceAll(' ', "").isEmpty);
  for (var i = 3; i < splitStrings.length - 1; i++) {
    CVInfoGroup? tempInfoGroup = keywordToGroupMap.entries
        .firstWhere(
          (element) => splitStrings[i].contains(element.key),
          orElse: () => const MapEntry("", null),
        )
        .value;
    if (tempInfoGroup != null) {
      currentInfoGroup = tempInfoGroup;
      continue;
    }
    currentInfoGroup?.parameters.add(splitStrings[i]);
    for (var ig in infoGroups) {
      for (var kw in ig.keywords) {
        if (splitStrings[i].toUpperCase().startsWith(kw.toUpperCase())) {
          List<String> parameters = splitStrings[i].split(": ");
          if (parameters.length == 1) {
            currentInfoGroup?.parameters.add(splitStrings[i]
                .replaceRange(0, 1, splitStrings[i][0].toUpperCase()));
            continue;
          }
          parameters = parameters[1].split(", ");
          parameters
              .removeWhere((element) => element.replaceAll(" ", "").isEmpty);
          for (var j = 0; j < parameters.length; j++) {
            parameters[j] = parameters[j]
                .replaceRange(0, 1, parameters[j][0].toUpperCase());
          }
          if (parameters.isEmpty) {
            continue;
          }
          ig.parameters.addAll(parameters);
        }
      }
    }
  }
  return infoGroups;
}

Future<CVInfo?> fromCVString(String cvString, String fileName) async {
  List<CVInfoGroup>? infoGroups; // = await _infoGroupsWithAPI(cvString)
  ;
  infoGroups ??= _infoGroupsWithoutAPI(cvString);
  return CVInfo(cvString, fileName, infoGroups);
}

Future<List<CVInfo>> getCVInfos() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
      allowMultiple: true);
  final List<CVInfo> cvs = [];
  if (result != null) {
    for (var pf in result.files) {
      PdfDocument document = PdfDocument(inputBytes: pf.bytes);
      String text = PdfTextExtractor(document).extractText();
      document.dispose();
      CVInfo? cv = await fromCVString(text, pf.name);
      if (cv != null) {
        cvs.add(cv);
      }
    }
  }
  return cvs;
}
