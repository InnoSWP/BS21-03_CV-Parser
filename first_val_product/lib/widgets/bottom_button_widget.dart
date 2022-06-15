import 'dart:ui';

import 'package:flutter/material.dart';

class BottomButtonWidget extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  BottomButtonWidget({required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
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
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.015,
                fontFamily: 'Marriweather'),
          ),
        ));
  }
}
