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
    return Container(
        margin: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: SizedBox(
            //height: double.infinity,
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
              //Column(children: jsonHolderBoxes,)
              Text(
            text,
            style: const TextStyle(
              fontFamily: 'Marriweather',
              fontSize: 50,
              color: Color.fromRGBO(73, 69, 79, 1),
            ),
          ),
        )));
  }
}
