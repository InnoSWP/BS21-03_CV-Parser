import 'package:first_val_product/backend.dart';
import 'package:first_val_product/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class JsonHolderBox extends StatefulWidget {
  final CVInfoGroup infoGroup;
  const JsonHolderBox({required this.infoGroup, Key? key}) : super(key: key);

  @override
  State<JsonHolderBox> createState() => _JsonHolderBoxState();
}

class _JsonHolderBoxState extends State<JsonHolderBox> {
  void _showDialog() {
    Future.delayed(const Duration(microseconds: 10), () {
      showDialog(
          context: context,
          builder: (_) => SimpleDialog(
                backgroundColor: const Color(0xFFFBFDF7),
                title: const Center(
                  child: Text(
                    'Do you want to report an error?',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFF864921),
                      fontFamily: 'Marriweather',
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.all(25),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF864921)),
                        child: Container(
                            //margin: EdgeInsets.all(10),
                            width: 45,
                            height: 35,
                            color: const Color(0xFF864921),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Text('yes',
                                    style: TextStyle(
                                      fontFamily: 'Marriweather',
                                    )),
                                Icon(
                                  Icons.check,
                                  size: 15,
                                )
                              ],
                            ) /*Center(
                        child: Text('yes', style: TextStyle(fontFamily: 'Marriweather',),),
                      ),*/
                            ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF864921)),
                        child: Container(
                          color: const Color(0xFF864921),
                          width: 40,
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text('no',
                                  style: TextStyle(
                                    fontFamily: 'Marriweather',
                                  )),
                              Icon(
                                Icons.close,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFE9F1E8),
              border: Border.all(color: const Color(0xFF49454F), width: 0.2)),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              widget.infoGroup.name,
              style: const TextStyle(
                  fontFamily: 'Marriweather',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF864921),
                  fontSize: 30),
            ),
            children: [
              ListView.separated(
                  padding: const EdgeInsets.all(15),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.infoGroup.parameters[index],
                            style: const TextStyle(
                              fontFamily: 'Marriweather',
                              fontSize: 20,
                              color: Color(0xFF49454F),
                            )),
                        IconButton(
                            splashRadius: 30,
                            onPressed: () {
                              _showDialog();
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF864921),
                            ))
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Color(0xFF49454F),
                    );
                  },
                  itemCount: widget.infoGroup.parameters.length)
            ],
          )
          /*ListView.separated(
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
              })*/
          ,
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
    /*Container(
        child: Text(
          infoGroup.name,
        ));*/
  }
}
