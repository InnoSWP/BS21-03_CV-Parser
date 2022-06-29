import 'package:flutter/material.dart';
class CircularWidget extends StatelessWidget {
  const CircularWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4D6658))),
          ),
        )
      ],
    );
  }
}
