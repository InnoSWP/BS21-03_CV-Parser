import 'package:first_val_product/backend.dart';
import 'package:first_val_product/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class JsonHolderBox extends StatelessWidget {
  final CVInfoGroup infoGroup;
  const JsonHolderBox({required this.infoGroup, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ListView.separated(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: infoGroup.parameters.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0)
                  return Text(
                    infoGroup.name,
                    style: TextStyle(
                        fontFamily: 'Marriweather',
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(134, 73, 33, 1),
                        fontSize: 30),
                  );
                else {
                  return Text(
                    infoGroup.parameters[index - 1],
                    style: TextStyle(
                      fontFamily: 'Marriweather',
                      fontSize: 20,
                      color: const Color.fromRGBO(73, 69, 79, 1),
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: const Color.fromRGBO(73, 69, 79, 1),
                );
              }),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromRGBO(233, 241, 231, 1),
              border: Border.all(color: Colors.black)),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
    /*Container(
        child: Text(
          infoGroup.name,
        ));*/
  }
}
