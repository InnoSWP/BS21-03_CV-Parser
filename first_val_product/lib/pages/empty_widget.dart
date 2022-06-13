import 'package:flutter/material.dart';
class EmptyWidget extends StatefulWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  @override
  Widget build(BuildContext context) {
    return  Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child:  Container(
          child: Text(
            'Select a resume to view the information',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40,
              fontFamily: 'Marriweather',),
          ),
        ),)
       ],
    )
    ;
  }
}
