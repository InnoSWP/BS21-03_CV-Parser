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
    await backend.getCVString().then((value) {
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
        backgroundColor: const Color.fromRGBO(251, 253, 247, 1),
        /*appBar: AppBar(

        title: const Text(
          "iExtract",
          style: TextStyle(
              fontFamily: 'Eczar',
              fontSize: 60,
              color: Color.fromRGBO(134, 73, 33, 1.0)),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),*/
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*Expanded(child: */ Container(
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
                  Expanded(
                    child: jsonHolder,
                  ),
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
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.02,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(251, 253, 247, 1),
                      border: Border.all(
                          width: 1, color: const Color.fromRGBO(73, 69, 79, 1)),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        size: MediaQuery.of(context).size.width * 0.015,
                        Icons.search,
                        color: const Color.fromRGBO(73, 69, 79, 1),
                      ),
                      label: Text(
                        'search',
                        style: TextStyle(
                          color: const Color.fromRGBO(73, 69, 79, 1),
                          fontFamily: 'Marriweather',
                          fontSize: MediaQuery.of(context).size.width * 0.01,
                        ),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        //minimumSize: MaterialStateProperty.all(const Size(140, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                    ),
                  ),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(1),
                                          height:
                                          MediaQuery.of(context).size.width *
                                              0.11,
                                          width: MediaQuery.of(context).size.width *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color:
                                                const Color.fromRGBO(73, 69, 79, 1)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(left: 65),
                                                child: IconButton(icon: Icon(Icons.close, size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.013,  color: Color.fromRGBO(73, 69, 79, 1),), onPressed: () {  },)
                                                /*Icon(Icons.close, color: Color.fromRGBO(73, 69, 79, 1),
                                                  size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.015,
                                                ),*/
                                              ),
                                              Container(
                                                  child: Icon(
                                                      Icons
                                                          .insert_drive_file_outlined,
                                                      color: const Color.fromRGBO(
                                                          77, 102, 88, 1),
                                                      size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.06)),
                                              Container(
                                                padding: const EdgeInsets.only(left: 8),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.06,
                                                child: Text(
                                                  "yourFilek.aboba",
                                                  style: TextStyle(
                                                      color: const Color.fromRGBO(
                                                          73, 69, 79, 1),
                                                      fontSize:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.006),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(1),
                                          height:
                                          MediaQuery.of(context).size.width *
                                              0.11,
                                          width: MediaQuery.of(context).size.width *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color:
                                                const Color.fromRGBO(73, 69, 79, 1)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.only(left: 65),
                                                  child: IconButton(icon: Icon(Icons.close, size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.013,  color: Color.fromRGBO(73, 69, 79, 1),), onPressed: () {  },)
                                                /*Icon(Icons.close, color: Color.fromRGBO(73, 69, 79, 1),
                                                  size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.015,
                                                ),*/
                                              ),
                                              Container(
                                                  child: Icon(
                                                      Icons
                                                          .insert_drive_file_outlined,
                                                      color: const Color.fromRGBO(
                                                          77, 102, 88, 1),
                                                      size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.06)),
                                              Container(
                                                padding: const EdgeInsets.only(left: 8),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.06,
                                                child: Text(
                                                  "yourFilek.aboba",
                                                  style: TextStyle(
                                                      color: const Color.fromRGBO(
                                                          73, 69, 79, 1),
                                                      fontSize:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.006),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                      ],
                                    )

                                  ],
                                )
                                ))),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.03,
                  )
                ],
              ),
            )
                )
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
