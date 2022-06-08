import 'package:flutter/material.dart';

class JsonHolder extends StatefulWidget {
  JsonHolder({Key? key}) : super(key: key);
  late State<JsonHolder> state;
  @override
  State<JsonHolder> createState() {
    state = _JsonHolderState();
    return state;
  }

  late String currentText =
      'In this course  Hover Fopment. Topics winges, Hover Functionality, Modals and more.In Responsive  go. n this course  Hover Fopment. Topics winges, Hover Functionality, Modals and more.In Responsive  go n this course  Hover Fopment. Topics winges, Hover Functionality, Modals and more.In Responsive  gon this course  Hover Fopment. Topics winges, Hover Functionality, Modals and more.In Responsive  gon this course  Hover Fopment. Topics winges, Hover Functionality, Modals and more.In Responsive  go';
  void updateText(String newText) {
    state.setState(() {
      currentText = newText;
    });
  }
}

class _JsonHolderState extends State<JsonHolder> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                widget.currentText,
                style: const TextStyle(
                  fontFamily: 'Marriweather',
                  fontSize: 50,
                  color: Color.fromRGBO(255, 77, 102, 1.0),
                ),
              ),
            )));
  }
}
