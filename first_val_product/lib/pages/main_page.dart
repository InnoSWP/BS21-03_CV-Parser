import 'dart:io';
import 'package:flutter/material.dart';
import 'json_holder.dart';
import 'package:first_val_product/backend.dart' as backend;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late File file;
  JsonHolder jsonHolder = JsonHolder();
  void onAddResume() async {
    File? newFile = await backend.getCV();
    if (newFile != null) {
      file = newFile;
    }
    await backend.pdfToString(file).then((value) {
      if (value != null) {
        jsonHolder.updateText(value);
      } else {
        jsonHolder.updateText("Loaded text");
      }
    });
  }

  void onExportJson(String json, String fileName) async {
    await backend.exportCV("jsonString", "fileName");
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 1000;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "iExtract",
          style: TextStyle(
              fontFamily: 'Eczar',
              fontSize: 50,
              color: Color.fromRGBO(255, 112, 55, 1.0)),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: jsonHolder,
          ),
          Expanded(
              child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            direction: isScreenWide ? Axis.horizontal : Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 3,
                    color: const Color.fromRGBO(255, 77, 102, 1.0),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: onAddResume,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(140, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    "Add resume",
                    style: TextStyle(
                        color: Color.fromRGBO(255, 77, 102, 1.0),
                        fontSize: 25,
                        fontFamily: 'Marriweather'),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 3,
                    color: const Color.fromRGBO(255, 77, 102, 1.0),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    onExportJson("json", "fileName");
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(140, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    "Export file",
                    style: TextStyle(
                        color: Color.fromRGBO(255, 77, 102, 1.0),
                        fontSize: 25,
                        fontFamily: 'Marriweather'),
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
