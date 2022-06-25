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
        (element) => element.contains("@"),
        orElse: () => "No email found");
    coolText = "";
    for (var infoGroup in infoGroups) {
      coolText += "${infoGroup.name}:\n";
      for (var parameter in infoGroup.parameters) {
        coolText += "    $parameter,\n";
      }
      coolText =
          coolText.replaceRange(coolText.length - 2, coolText.length - 1, ";");
    }
    print(coolText);
  }
  CVInfoGroup? _getInfoGroup(String infoGroupName) {
    for (CVInfoGroup infoGroup in infoGroups) {
      if (infoGroup.name == infoGroupName) {
        return infoGroup;
      }
    }
    return null;
  }

  Future export({required String postfix}) async {
    Directory directory = await getApplicationDocumentsDirectory();
    print("${directory.path}\\$fileName.json");
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
      .replaceAll('\n', '')
      .replaceAll('\r', '')
      .replaceAll("\\\\n", "")
      .replaceAll("\\\\t", "")
      .replaceAll("\\t", "")
      .replaceAll("\\r", "")
      .split('\\n');
  {
    List<String> temp = [];
    splitStrings.forEach((element) => temp.addAll(element.split('\n')));
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
  for (var i = 3; i < splitStrings.length; i++) {
    print(splitStrings[i]);
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
          if (parameters.isEmpty) continue;
          ig.parameters.addAll(parameters);
        }
      }
    }
  }
  return infoGroups;
  /*
  return await '[{"match":"research","label":"CsSkill","sentence":""},{"match":"Android","label":"CsSkill","sentence":""},{"match":"Java","label":"CsSkill","sentence":""},{"match":"api","label":"CsSkill","sentence":""},{"match":"UI","label":"CsSkill","sentence":""},{"match":"UX","label":"CsSkill","sentence":""},{"match":"Software","label":"CsSkill","sentence":""},{"match":"software","label":"CsSkill","sentence":""},{"match":"courses","label":"CsSkill","sentence":""},{"match":"Algorithm","label":"CsSkill","sentence":""},{"match":"Programming","label":"CsSkill","sentence":""},{"match":"Videos","label":"CsSkill","sentence":""},{"match":"design","label":"CsSkill","sentence":""},{"match":"streaming","label":"CsSkill","sentence":""},{"match":"marketing","label":"CsSkill","sentence":""},{"match":"Mobile","label":"CsSkill","sentence":""},{"match":"MIT","label":"CsSkill","sentence":""},{"match":"REST","label":"CsSkill","sentence":""},{"match":"Material","label":"CsSkill","sentence":""},{"match":"C++","label":"CsSkill","sentence":""},{"match":"offline","label":"CsSkill","sentence":""},{"match":"SDK","label":"CsSkill","sentence":""},{"match":"Design","label":"CsSkill","sentence":""},{"match":"e-commerce","label":"CsSkill","sentence":""},{"match":"Chat","label":"CsSkill","sentence":""},{"match":"cloud","label":"CsSkill","sentence":""},{"match":"animation","label":"CsSkill","sentence":""},{"match":"material","label":"CsSkill","sentence":""},{"match":"Dialog","label":"CsSkill","sentence":""},{"match":"flow","label":"CsSkill","sentence":""},{"match":"client","label":"CsSkill","sentence":""},{"match":"mobile","label":"CsSkill","sentence":""},{"match":"Imam\\n+962798982930","label":"ORG","sentence":"\"\\nMuwaffaq Imam\\n+962798982930 | \r\n+7 (917) 905-50-38\r\n |"},{"match":"Innopolis City","label":"PERSON","sentence":"Innopolis City | LinkedIn | research gate  | Telegram @moofiy\\n\\\r\nnSKILLS\\nTechnical: Android, Flutter, Java, Dart, Fast api, UI/UX Designer, \r\nFirebase, \\n\\nSoft skills: development coach and Instructor, vLogger, Public \r\nspeaking, presentation skills, content creator."},{"match":"UI/UX Designer","label":"ORG","sentence":"Innopolis City | LinkedIn | research gate  | Telegram @moofiy\\n\\\r\nnSKILLS\\nTechnical: Android, Flutter, Java, Dart, Fast api, UI/UX Designer, \r\nFirebase, \\n\\nSoft skills: development coach and Instructor, vLogger, Public \r\nspeaking, presentation skills, content creator."},{"match":"Firebase","label":"ORG","sentence":"Innopolis City | LinkedIn | research gate  | Telegram @moofiy\\n\\\r\nnSKILLS\\nTechnical: Android, Flutter, Java, Dart, Fast api, UI/UX Designer, \r\nFirebase, \\n\\nSoft skills: development coach and Instructor, vLogger, Public \r\nspeaking, presentation skills, content creator."},{"match":"Instructor","label":"ORG","sentence":"Innopolis City | LinkedIn | research gate  | Telegram @moofiy\\n\\\r\nnSKILLS\\nTechnical: Android, Flutter, Java, Dart, Fast api, UI/UX Designer, \r\nFirebase, \\n\\nSoft skills: development coach and Instructor, vLogger, Public \r\nspeaking, presentation skills, content creator."},{"match":"vLogger","label":"ORG","sentence":"Innopolis City | LinkedIn | research gate  | Telegram @moofiy\\n\\\r\nnSKILLS\\nTechnical: Android, Flutter, Java, Dart, Fast api, UI/UX Designer, \r\nFirebase, \\n\\nSoft skills: development coach and Instructor, vLogger, Public \r\nspeaking, presentation skills, content creator."},{"match":"Arabic","label":"LANGUAGE","sentence":"\\nLanguages: Arabic (Native), \r\nEnglish (Fluent), Japanese (beginner)\\n\\nEDUCATION\\nInnopolis University - Phd (in \r\nProgress)  2021-PRESENT\\nInnopolis University - Currently a Masterâs Degree in MSIT\r\nSoftware Engineering."},{"match":"English","label":"LANGUAGE","sentence":"\\nLanguages: Arabic (Native), \r\nEnglish (Fluent), Japanese (beginner)\\n\\nEDUCATION\\nInnopolis University - Phd (in \r\nProgress)  2021-PRESENT\\nInnopolis University - Currently a Masterâs Degree in MSIT\r\nSoftware Engineering."},{"match":"Japanese","label":"NORP","sentence":"\\nLanguages: Arabic (Native), \r\nEnglish (Fluent), Japanese (beginner)\\n\\nEDUCATION\\nInnopolis University - Phd (in \r\nProgress)  2021-PRESENT\\nInnopolis University - Currently a Masterâs Degree in MSIT\r\nSoftware Engineering."},{"match":"beginner)\\n\\nEDUCATION\\nInnopolis University - Phd","label":"ORG","sentence":"\\nLanguages: Arabic (Native), \r\nEnglish (Fluent), Japanese (beginner)\\n\\nEDUCATION\\nInnopolis University - Phd (in \r\nProgress)  2021-PRESENT\\nInnopolis University - Currently a Masterâs Degree in MSIT\r\nSoftware Engineering."},{"match":"University - Currently","label":"ORG","sentence":"\\nLanguages: Arabic (Native), \r\nEnglish (Fluent), Japanese (beginner)\\n\\nEDUCATION\\nInnopolis University - Phd (in \r\nProgress)  2021-PRESENT\\nInnopolis University - Currently a Masterâs Degree in MSIT\r\nSoftware Engineering."},{"match":"MSIT\r\nSoftware Engineering","label":"ORG","sentence":"\\nLanguages: Arabic (Native), \r\nEnglish (Fluent), Japanese (beginner)\\n\\nEDUCATION\\nInnopolis University - Phd (in \r\nProgress)  2021-PRESENT\\nInnopolis University - Currently a Masterâs Degree in MSIT\r\nSoftware Engineering."},{"match":"Innopolis University\\t\\t\\t2019","label":"PERSON","sentence":"Engineering - Class of 2010\\n\\nINSTRUCTING EXPERIENCE  \\nPhd student, Researcher \r\nand TA at Innopolis University\\t\\t\\t2019 - PRESENT\\t\\nI teach my own Flutter Course\r\nwith Innopolis University.\\nResearcher and Doing a thesis for a Master degree on \r\nEnhance Online education in software engineering \\nTA and Responsible teaching / \r\ncreating laps for the following courses: Information theory, Data structure and \r\nAlgorithm and Introduction to Programming using C++.\\nOrganized of Innolaps a \r\nYoutube channel that produced content related to Innopolis and I help with \\\r\n"},{"match":"Innopolis","label":"PERSON","sentence":"Engineering - Class of 2010\\n\\nINSTRUCTING EXPERIENCE  \\nPhd student, Researcher \r\nand TA at Innopolis University\\t\\t\\t2019 - PRESENT\\t\\nI teach my own Flutter Course\r\nwith Innopolis University.\\nResearcher and Doing a thesis for a Master degree on \r\nEnhance Online education in software engineering \\nTA and Responsible teaching / \r\ncreating laps for the following courses: Information theory, Data structure and \r\nAlgorithm and Introduction to Programming using C++.\\nOrganized of Innolaps a \r\nYoutube channel that produced content related to Innopolis and I help with \\\r\n"},{"match":"Data","label":"ORG","sentence":"Engineering - Class of 2010\\n\\nINSTRUCTING EXPERIENCE  \\nPhd student, Researcher \r\nand TA at Innopolis University\\t\\t\\t2019 - PRESENT\\t\\nI teach my own Flutter Course\r\nwith Innopolis University.\\nResearcher and Doing a thesis for a Master degree on \r\nEnhance Online education in software engineering \\nTA and Responsible teaching / \r\ncreating laps for the following courses: Information theory, Data structure and \r\nAlgorithm and Introduction to Programming using C++.\\nOrganized of Innolaps a \r\nYoutube channel that produced content related to Innopolis and I help with \\\r\n"},{"match":"Innolaps","label":"GPE","sentence":"Engineering - Class of 2010\\n\\nINSTRUCTING EXPERIENCE  \\nPhd student, Researcher \r\nand TA at Innopolis University\\t\\t\\t2019 - PRESENT\\t\\nI teach my own Flutter Course\r\nwith Innopolis University.\\nResearcher and Doing a thesis for a Master degree on \r\nEnhance Online education in software engineering \\nTA and Responsible teaching / \r\ncreating laps for the following courses: Information theory, Data structure and \r\nAlgorithm and Introduction to Programming using C++.\\nOrganized of Innolaps a \r\nYoutube channel that produced content related to Innopolis and I help with \\\r\n"},{"match":"the Videos Traffic","label":"ORG","sentence":"nMontage and Organize the channel \\nDoing SEO and enhance the Videos Traffic and \r\ndesign Thumbnails for lessons\\nAdding Youtube chapters \\nHelp Organized conferences\r\nheld in Inno, such OSS \\nOSS, I was the designer creating video posts for social \r\nmedia, \\nResponsible to manage live streaming from zoom to Facebook and track \r\nclicking\\nCommunicating with Speakers and record marketing video with them \\nAdd \r\nsome calm music in the breaks \\nContributed and helped to ITTC 2020 conference held\r\nin innopolis\\nContributed to the conference \\nPublish the paper to the journal of \r\nphysics  a paper about online learning \\nHelp with music and video montage.\\\r\n"},{"match":"Organized","label":"ORG","sentence":"nMontage and Organize the channel \\nDoing SEO and enhance the Videos Traffic and \r\ndesign Thumbnails for lessons\\nAdding Youtube chapters \\nHelp Organized conferences\r\nheld in Inno, such OSS \\nOSS, I was the designer creating video posts for social \r\nmedia, \\nResponsible to manage live streaming from zoom to Facebook and track \r\nclicking\\nCommunicating with Speakers and record marketing video with them \\nAdd \r\nsome calm music in the breaks \\nContributed and helped to ITTC 2020 conference held\r\nin innopolis\\nContributed to the conference \\nPublish the paper to the journal of \r\nphysics  a paper about online learning \\nHelp with music and video montage.\\\r\n"},{"match":"Inno","label":"ORG","sentence":"nMontage and Organize the channel \\nDoing SEO and enhance the Videos Traffic and \r\ndesign Thumbnails for lessons\\nAdding Youtube chapters \\nHelp Organized conferences\r\nheld in Inno, such OSS \\nOSS, I was the designer creating video posts for social \r\nmedia, \\nResponsible to manage live streaming from zoom to Facebook and track \r\nclicking\\nCommunicating with Speakers and record marketing video with them \\nAdd \r\nsome calm music in the breaks \\nContributed and helped to ITTC 2020 conference held\r\nin innopolis\\nContributed to the conference \\nPublish the paper to the journal of \r\nphysics  a paper about online learning \\nHelp with music and video montage.\\\r\n"},{"match":"OSS \\nOSS","label":"ORG","sentence":"nMontage and Organize the channel \\nDoing SEO and enhance the Videos Traffic and \r\ndesign Thumbnails for lessons\\nAdding Youtube chapters \\nHelp Organized conferences\r\nheld in Inno, such OSS \\nOSS, I was the designer creating video posts for social \r\nmedia, \\nResponsible to manage live streaming from zoom to Facebook and track \r\nclicking\\nCommunicating with Speakers and record marketing video with them \\nAdd \r\nsome calm music in the breaks \\nContributed and helped to ITTC 2020 conference held\r\nin innopolis\\nContributed to the conference \\nPublish the paper to the journal of \r\nphysics  a paper about online learning \\nHelp with music and video montage.\\\r\n"},{"match":"American University","label":"ORG","sentence":"nResponsible to Producing High quality courses [look at a sample]\\nHelp producing \r\nLSD Course \\nEdit the video and produce a full lecturer \\nGuest Lecturer at \r\nAmerican University in Emirates AUE  \\t\\t\\t[Certificate URL]       \\nI gave a \r\nsession on Mobile development using MIT App inventor \\nBuild an advanced \r\napplication using sensors, firebase, and REST API\\nWe manage to build 4 apps within\r\n"},{"match":"\\nBuild","label":"ORG","sentence":"nResponsible to Producing High quality courses [look at a sample]\\nHelp producing \r\nLSD Course \\nEdit the video and produce a full lecturer \\nGuest Lecturer at \r\nAmerican University in Emirates AUE  \\t\\t\\t[Certificate URL]       \\nI gave a \r\nsession on Mobile development using MIT App inventor \\nBuild an advanced \r\napplication using sensors, firebase, and REST API\\nWe manage to build 4 apps within\r\n"},{"match":"\\n\\nInnopolis","label":"NORP","sentence":"this short session \\n\\nInnopolis schools Development Instructor :"},{"match":"the \r\nMaterial","label":"ORG","sentence":"        \r\n2021 - PRESENT\\nResponsible to teach international students Flutter\\nCreate the \r\nMaterial, quizzes and projects for the students.\\nDevelopment Instructor- Code \r\n"},{"match":"Circle","label":"WORK_OF_ART","sentence":"Circle :   \\t\\t\\t\\t\\t\\t     2017- 2020\\nProvided offline/ online courses in Mobile \r\ndevelopment for kids and adults ages 9-18 plus:\\nDesigned and taught  20H, 30H, and\r\n50 Hours curriculums \\nI taught Android, Java, App Inventors, C++, and Flutter for \r\nboth kids and adults\\nHere is some screenshot of what my student delivered \\nTaught\r\nover 100 students."},{"match":"Amman","label":"GPE","sentence":"In Amman and Tafielah\\n\\nFounded  of MoofiyTv.com\\nprovide \r\nOnline/ offline courses in multiple areas in computer science \\nDesigned and taught\r\nmultiple courses in Computer science and software engineering \\nIâm creating online\r\ncourses for software engineering and system design\\nIâm creating Computer science \r\ncourses fundamental just like Data structure\\n\\nYoutube Creator  \\t\\t\\t\\t     \\t\\t\\\r\nt\\t   2020 - PRESENT\\nFounder of MoofiyTv Youtube channel, I focused on delivering \r\nIT-related content in Arabic including \\nAdvice to new students and how to study \r\nand learn Programming \\nFree tutorial on how to use tools, or explaining an \r\nadvanced concept in simple terms\\nStarting a new program called 100 Programming \r\n"},{"match":"MoofiyTv.com\\nprovide","label":"ORG","sentence":"In Amman and Tafielah\\n\\nFounded  of MoofiyTv.com\\nprovide \r\nOnline/ offline courses in multiple areas in computer science \\nDesigned and taught\r\nmultiple courses in Computer science and software engineering \\nIâm creating online\r\ncourses for software engineering and system design\\nIâm creating Computer science \r\ncourses fundamental just like Data structure\\n\\nYoutube Creator  \\t\\t\\t\\t     \\t\\t\\\r\nt\\t   2020 - PRESENT\\nFounder of MoofiyTv Youtube channel, I focused on delivering \r\nIT-related content in Arabic including \\nAdvice to new students and how to study \r\nand learn Programming \\nFree tutorial on how to use tools, or explaining an \r\nadvanced concept in simple terms\\nStarting a new program called 100 Programming \r\n"},{"match":"Computer","label":"ORG","sentence":"In Amman and Tafielah\\n\\nFounded  of MoofiyTv.com\\nprovide \r\nOnline/ offline courses in multiple areas in computer science \\nDesigned and taught\r\nmultiple courses in Computer science and software engineering \\nIâm creating online\r\ncourses for software engineering and system design\\nIâm creating Computer science \r\ncourses fundamental just like Data structure\\n\\nYoutube Creator  \\t\\t\\t\\t     \\t\\t\\\r\nt\\t   2020 - PRESENT\\nFounder of MoofiyTv Youtube channel, I focused on delivering \r\nIT-related content in Arabic including \\nAdvice to new students and how to study \r\nand learn Programming \\nFree tutorial on how to use tools, or explaining an \r\nadvanced concept in simple terms\\nStarting a new program called 100 Programming \r\n"},{"match":"MoofiyTv Youtube","label":"ORG","sentence":"In Amman and Tafielah\\n\\nFounded  of MoofiyTv.com\\nprovide \r\nOnline/ offline courses in multiple areas in computer science \\nDesigned and taught\r\nmultiple courses in Computer science and software engineering \\nIâm creating online\r\ncourses for software engineering and system design\\nIâm creating Computer science \r\ncourses fundamental just like Data structure\\n\\nYoutube Creator  \\t\\t\\t\\t     \\t\\t\\\r\nt\\t   2020 - PRESENT\\nFounder of MoofiyTv Youtube channel, I focused on delivering \r\nIT-related content in Arabic including \\nAdvice to new students and how to study \r\nand learn Programming \\nFree tutorial on how to use tools, or explaining an \r\nadvanced concept in simple terms\\nStarting a new program called 100 Programming \r\n"},{"match":"Programming \r\n","label":"ORG","sentence":"In Amman and Tafielah\\n\\nFounded  of MoofiyTv.com\\nprovide \r\nOnline/ offline courses in multiple areas in computer science \\nDesigned and taught\r\nmultiple courses in Computer science and software engineering \\nIâm creating online\r\ncourses for software engineering and system design\\nIâm creating Computer science \r\ncourses fundamental just like Data structure\\n\\nYoutube Creator  \\t\\t\\t\\t     \\t\\t\\\r\nt\\t   2020 - PRESENT\\nFounder of MoofiyTv Youtube channel, I focused on delivering \r\nIT-related content in Arabic including \\nAdvice to new students and how to study \r\nand learn Programming \\nFree tutorial on how to use tools, or explaining an \r\nadvanced concept in simple terms\\nStarting a new program called 100 Programming \r\n"},{"match":"Answering","label":"ORG","sentence":"Advice for every day to 100 days ( in progress)\\nLive streaming and Answering and \r\nguiding students to the world of IT \\nPROFESSIONAL EXPERIENCE \\nWith +6 years \r\nprofessionally working in the market \\nYaqut LTD, Android Developer \\t\\t\\t\\t\\t\\t\\t \r\n2016 - 2019\\t\\nDeveloped an E-commerce Application with a reach of over 1M Users\\\r\nnEngaged in enhancing the design of the app and Magento SDK to be compatible with \r\nthe project requirement.\\nYAAB LTD, Android Developer \\t\\t\\t\\t\\t \\t\\t 2015 - 2016\\\r\nt\\nWorked with a team of 5 on multiple projects mostly Aggregation apps\\\r\n"},{"match":"Magento SDK","label":"ORG","sentence":"Advice for every day to 100 days ( in progress)\\nLive streaming and Answering and \r\nguiding students to the world of IT \\nPROFESSIONAL EXPERIENCE \\nWith +6 years \r\nprofessionally working in the market \\nYaqut LTD, Android Developer \\t\\t\\t\\t\\t\\t\\t \r\n2016 - 2019\\t\\nDeveloped an E-commerce Application with a reach of over 1M Users\\\r\nnEngaged in enhancing the design of the app and Magento SDK to be compatible with \r\nthe project requirement.\\nYAAB LTD, Android Developer \\t\\t\\t\\t\\t \\t\\t 2015 - 2016\\\r\nt\\nWorked with a team of 5 on multiple projects mostly Aggregation apps\\\r\n"},{"match":"requirement.\\nYAAB LTD","label":"ORG","sentence":"Advice for every day to 100 days ( in progress)\\nLive streaming and Answering and \r\nguiding students to the world of IT \\nPROFESSIONAL EXPERIENCE \\nWith +6 years \r\nprofessionally working in the market \\nYaqut LTD, Android Developer \\t\\t\\t\\t\\t\\t\\t \r\n2016 - 2019\\t\\nDeveloped an E-commerce Application with a reach of over 1M Users\\\r\nnEngaged in enhancing the design of the app and Magento SDK to be compatible with \r\nthe project requirement.\\nYAAB LTD, Android Developer \\t\\t\\t\\t\\t \\t\\t 2015 - 2016\\\r\nt\\nWorked with a team of 5 on multiple projects mostly Aggregation apps\\\r\n"},{"match":"Aggregation","label":"ORG","sentence":"Advice for every day to 100 days ( in progress)\\nLive streaming and Answering and \r\nguiding students to the world of IT \\nPROFESSIONAL EXPERIENCE \\nWith +6 years \r\nprofessionally working in the market \\nYaqut LTD, Android Developer \\t\\t\\t\\t\\t\\t\\t \r\n2016 - 2019\\t\\nDeveloped an E-commerce Application with a reach of over 1M Users\\\r\nnEngaged in enhancing the design of the app and Magento SDK to be compatible with \r\nthe project requirement.\\nYAAB LTD, Android Developer \\t\\t\\t\\t\\t \\t\\t 2015 - 2016\\\r\nt\\nWorked with a team of 5 on multiple projects mostly Aggregation apps\\\r\n"},{"match":"Using Flutter","label":"ORG","sentence":"nParticipated in design decisions and customer meetings Engaged in meetings and \r\nparticipated in design decision plus presentation\\nApplikable LTD,  Android \r\nDeveloper \\t\\t\\t\\t\\t\\t\\t 2014 - 2015\\t\\nDeveloping the full project alone including\r\nthe UI Design\\nCreating a student portal application using web scraping and convert\r\ndata to apps\\n\\n\\n\\nDEVELOPMENT- PROJECTS \\nSookOkaz: an e-book reader and store \r\nbuilt Using Flutter, I was responsible for managing the Web team and creating the \r\nMobile version.\\nLinks [ Playstore, Web, Demo video]\\nPrayer App  a reminder for \r\nNamaz ( prayer ) using Flutter\\n\r\nÙ¬"},{"match":"Playstore","label":"PERSON","sentence":"nParticipated in design decisions and customer meetings Engaged in meetings and \r\nparticipated in design decision plus presentation\\nApplikable LTD,  Android \r\nDeveloper \\t\\t\\t\\t\\t\\t\\t 2014 - 2015\\t\\nDeveloping the full project alone including\r\nthe UI Design\\nCreating a student portal application using web scraping and convert\r\ndata to apps\\n\\n\\n\\nDEVELOPMENT- PROJECTS \\nSookOkaz: an e-book reader and store \r\nbuilt Using Flutter, I was responsible for managing the Web team and creating the \r\nMobile version.\\nLinks [ Playstore, Web, Demo video]\\nPrayer App  a reminder for \r\nNamaz ( prayer ) using Flutter\\n\r\nÙ¬"},{"match":"Flutter\\n","label":"ORG","sentence":"nParticipated in design decisions and customer meetings Engaged in meetings and \r\nparticipated in design decision plus presentation\\nApplikable LTD,  Android \r\nDeveloper \\t\\t\\t\\t\\t\\t\\t 2014 - 2015\\t\\nDeveloping the full project alone including\r\nthe UI Design\\nCreating a student portal application using web scraping and convert\r\ndata to apps\\n\\n\\n\\nDEVELOPMENT- PROJECTS \\nSookOkaz: an e-book reader and store \r\nbuilt Using Flutter, I was responsible for managing the Web team and creating the \r\nMobile version.\\nLinks [ Playstore, Web, Demo video]\\nPrayer App  a reminder for \r\nNamaz ( prayer ) using Flutter\\n\r\nÙ¬"},{"match":"Links  Source Code |","label":"ORG","sentence":"Links  Source Code |"},{"match":"middle east","label":"LOC","sentence":"Birth & Beyond, petsooq, \r\nibackzone\\nJarir store: e-commerce application for one of the big companies in the \r\nmiddle east  it builds using Magento SDK\\nLinks : [ Play store ] \\nYaqut : e-Book \r\nstore, and audio books library, I partially wrote some code not fully developed \\\r\n"},{"match":"Magento","label":"ORG","sentence":"Birth & Beyond, petsooq, \r\nibackzone\\nJarir store: e-commerce application for one of the big companies in the \r\nmiddle east  it builds using Magento SDK\\nLinks : [ Play store ] \\nYaqut : e-Book \r\nstore, and audio books library, I partially wrote some code not fully developed \\\r\n"},{"match":"Firestore","label":"ORG","sentence":"[Play store]\\nChat Hub: Chat application built using Firestore and cloud \r\nfunctions, Native Scene animation, material design library \\nLinks :"},{"match":"Native Scene","label":"ORG","sentence":"[Play store]\\nChat Hub: Chat application built using Firestore and cloud \r\nfunctions, Native Scene animation, material design library \\nLinks :"},{"match":"Google","label":"ORG","sentence":"[APK]\\nFoodle: Food and dessert ordering app built with Native Scene animation, \r\nMaterial design component.\\nLinks  [Demo Video], [APK]\\nFoodle sweets a Google \r\n"},{"match":"Mobile Application Foodle","label":"ORG","sentence":"Assistant application that is connected to Mobile Application Foodle, build in \r\nDialog flow, Node.js, deep linking with Android\\nLinks :"},{"match":"Node.js","label":"GPE","sentence":"Assistant application that is connected to Mobile Application Foodle, build in \r\nDialog flow, Node.js, deep linking with Android\\nLinks :"},{"match":"EdgeVision","label":"ORG","sentence":"[Demo Video ]\\\r\nnSmartParking: working as clients for EdgeVision company on a client side mobile \r\napp for a smart parking service as a thesis for the Master Degree\\nLinks :"},{"match":"Play Store\\nJarir Reader","label":"ORG","sentence":"[Demo \r\nvideo]\\nOther projects on Play Store\\nJarir Reader, Dubai public library, Dubai \r\nculture, university student portal collections, \\nUI/UX Designs  \\nBelow is my \r\n"},{"match":"Dubai","label":"GPE","sentence":"[Demo \r\nvideo]\\nOther projects on Play Store\\nJarir Reader, Dubai public library, Dubai \r\nculture, university student portal collections, \\nUI/UX Designs  \\nBelow is my \r\n"},{"match":"Dubai \r\n","label":"ORG","sentence":"[Demo \r\nvideo]\\nOther projects on Play Store\\nJarir Reader, Dubai public library, Dubai \r\nculture, university student portal collections, \\nUI/UX Designs  \\nBelow is my \r\n"},{"match":"\\nUI/UX Designs","label":"ORG","sentence":"[Demo \r\nvideo]\\nOther projects on Play Store\\nJarir Reader, Dubai public library, Dubai \r\nculture, university student portal collections, \\nUI/UX Designs  \\nBelow is my \r\n"},{"match":"Mobile Design","label":"ORG","sentence":"Recent UI/UX Designs Projects \\nSookOkaz     [Demo video]  [ Web and Mobile Design"},{"match":"\\nFoodle","label":"PERSON","sentence":"\\nChat Hub      [Demo Video]  [Design Artboard ] \\nFoodle"},{"match":"muwaffaqimam@gmail.com","label":"emails","sentence":"muwaffaqimam@gmail.com"},{"match":"www.moofiyTv.com","label":"Links","sentence":"\r\nwww.moofiyTv.com"},{"match":"Node.js","label":"Links","sentence":"Assistant application that is connected to Mobile Application Foodle, build in \r\nDialog flow, Node.js, deep linking with Android\\nLinks :"},{"match":"Degree","label":"Degree","sentence":"\\nLanguages: Arabic (Native), \r\nEnglish (Fluent), Japanese (beginner)\\n\\nEDUCATION\\nInnopolis University - Phd (in \r\nProgress)  2021-PRESENT\\nInnopolis University - Currently a Masterâs Degree in MSIT\r\nSoftware Engineering."},{"match":"degree","label":"Degree","sentence":"Engineering - Class of 2010\\n\\nINSTRUCTING EXPERIENCE  \\nPhd student, Researcher \r\nand TA at Innopolis University\\t\\t\\t2019 - PRESENT\\t\\nI teach my own Flutter Course\r\nwith Innopolis University.\\nResearcher and Doing a thesis for a Master degree on \r\nEnhance Online education in software engineering \\nTA and Responsible teaching / \r\ncreating laps for the following courses: Information theory, Data structure and \r\nAlgorithm and Introduction to Programming using C++.\\nOrganized of Innolaps a \r\nYoutube channel that produced content related to Innopolis and I help with \\\r\n"}]';
  */
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
