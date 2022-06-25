import 'package:first_val_product/main_page.dart';
import 'package:first_val_product/widgets/json_holder_box.dart';
import 'package:flutter/material.dart';
import 'package:first_val_product/widgets/empty_widget.dart';

class JsonHolder extends StatelessWidget {
  final String text;
  const JsonHolder({required this.text, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<JsonHolderBox> jsonHolderBoxes = [];
    for (var cvInfoGroup in MainPage.instance.currentCVInfo!.infoGroups) {
      jsonHolderBoxes.add(JsonHolderBox(infoGroup: cvInfoGroup));
    }
    String appName = MainPage.instance.currentCVInfo!.applicantsEmail!;
    return Container(
        margin: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: SizedBox(
            //height: double.infinity,
            child: SingleChildScrollView(
                controller: ScrollController(
                    //initialScrollOffset: 40,
                    //keepScrollOffset: false
                    ),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                        height: 110,
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appName,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Marriweather',
                                    color: Color(0xFF49454F)),
                              ),
                              Icon(
                                Icons.person_outline,
                                size: 60,
                                color: Color(0xFF49454F),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFF2EEE1),
                            border: Border.all(
                                color: Color(0xFF49454F), width: 0.2))),
                    SizedBox(
                      height: 20,
                    ),
                    Column(children: jsonHolderBoxes)
                  ],
                  /*children:
                jsonHolderBoxes,*/
                )
                //   Text(
                // text,
                // style: const TextStyle(
                //   fontFamily: 'Marriweather',
                //   fontSize: 50,
                //   color: Color.fromRGBO(73, 69, 79, 1),
                // ),
                //),
                )));
  }
}
