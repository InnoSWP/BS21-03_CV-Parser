import 'dart:io';
import 'package:flutter/material.dart';
import 'json_holder.dart';
import 'package:first_val_product/backend.dart' as backend;
import 'package:first_val_product/pages/file_widget.dart';
import 'package:first_val_product/pages/search_widget.dart';
import 'package:first_val_product/pages/empty_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late File? file = null;

  JsonHolder jsonHolder = JsonHolder();
  void onAddResume() async {
    await backend.getCVInfo().then((value) {
      if (value != null) {
        jsonHolder.updateText(value.coolText);
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
    return Scaffold(
        backgroundColor: const Color.fromRGBO(251, 253, 247, 1),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.only(left: 30),
                    child: const Text(
                      'iExtract',
                      style: TextStyle(
                          fontSize: 70,
                          fontFamily: 'Eczar',
                          color: Color.fromRGBO(134, 73, 33, 1.0)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 1,
                      color: const Color.fromRGBO(73, 69, 79, 1),
                    ),
                  ),
                  Expanded(child: jsonHolder),
                ],
              ),
            ) /*)*/
            /*Expanded(
            child: jsonHolder,
          )*/
            ,
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SearchWidget(),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(5),
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.3,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FileWidget(),
                                        FileWidget(),
                                      ],
                                    )
                                  ],
                                )))),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.03,
                  )
                ],
              ),
            ))
          ],
        ),
        floatingActionButton: Wrap(
          direction: Axis.horizontal,
          children: [
            Container(
                height: MediaQuery.of(context).size.width * 0.04,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(77, 102, 88, 1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 0.5,
                    color: const Color.fromRGBO(73, 69, 79, 1.0),
                  ),
                ),
                child: RawMaterialButton(
                  shape: const CircleBorder(),
                  elevation: 0.0,
                  onPressed: onAddResume,
                  child: Text(
                    "Add resume",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.015,
                        fontFamily: 'Marriweather'),
                  ),
                )),
            Container(
                height: MediaQuery.of(context).size.width * 0.04,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(77, 102, 88, 1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 0.5,
                    color: const Color.fromRGBO(73, 69, 79, 1.0),
                  ),
                ),
                child: RawMaterialButton(
                  shape: const CircleBorder(),
                  elevation: 0.0,
                  child: Text(
                    "Export file",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.015,
                        fontFamily: 'Marriweather'),
                  ),
                  onPressed: () {
                    onExportJson("json", "fileName");
                  },
                )),
            Container(
                height: MediaQuery.of(context).size.width * 0.04,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(77, 102, 88, 1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 0.5,
                    color: const Color.fromRGBO(73, 69, 79, 1.0),
                  ),
                ),
                child: RawMaterialButton(
                  shape: const CircleBorder(),
                  elevation: 0.0,
                  child: Text(
                    "Export all",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.015,
                        fontFamily: 'Marriweather'),
                  ),
                  onPressed: () {},
                )),
          ],
        ));
  }
}
