import 'package:flutter/material.dart';
import 'package:first_val_product/widgets/empty_widget.dart';

class JsonHolder extends StatelessWidget {
  final String text;
  const JsonHolder({required this.text, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: SizedBox(
            //height: double.infinity,
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
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
