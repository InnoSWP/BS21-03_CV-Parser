import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        )
      ],
    );
  }
}
