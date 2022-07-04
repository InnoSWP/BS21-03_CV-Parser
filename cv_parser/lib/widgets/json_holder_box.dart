import 'package:cv_parser/backend.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class JsonHolderBox extends StatefulWidget {
  final CVInfoGroup infoGroup;
  const JsonHolderBox({required this.infoGroup, Key? key}) : super(key: key);

  @override
  State<JsonHolderBox> createState() => _JsonHolderBoxState();
}

class _JsonHolderBoxState extends State<JsonHolderBox> {
  String name = '';
  final CollectionReference parserErrors =
      FirebaseFirestore.instance.collection('parserErrors');
  String jsonString =
      '"match": "research","label": "CsSkill", "sentence": "", "reason": "user should write a reson why he is reporting this" ';
  void _sendError(String info, String sentence, String reason) async {
    String jsonString =
        '{"match" : "$sentence","label":"$info","sentence":"","reason":"$reason"}';
    Map<String, dynamic> d = json.decode(jsonString.trim());
    await parserErrors.add(d);
    _showSimpleDialog();
  }


  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }

  Future<void> _showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // <-- SEE HERE
            title: const Text('Thank You For Helping Us Develop!',
                style: TextStyle(
                  color: Color(0xFF864921),
                  fontFamily: 'Marriweather',
                )),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close',
                          style: TextStyle(
                            color: Color(0xFF864921),
                            fontFamily: 'Marriweather',
                          ))),
                  SizedBox(width: 35,)
                ],
              )
            ],
          );
        });
  }

  Future<String?> _showDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Provide a reason for flagging:',
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF864921),
                  fontFamily: 'Marriweather',
                )),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter a reason',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF49454F)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF49454F)),
                ),
              ),
              controller: controller,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CLOSE',
                          style: TextStyle(
                            color: Color(0xFF864921),
                            fontFamily: 'Marriweather',
                          ))),
                  TextButton(
                      onPressed: submit,
                      child: const Text('SUBMIT',
                          style: TextStyle(
                            color: Color(0xFF864921),
                            fontFamily: 'Marriweather',
                          ))),
                ],
              )
            ],
          ));

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
            iconColor: Color(0xFF49454F),
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.infoGroup.parameters[index],
                            softWrap: true,
                            style: const TextStyle(
                              fontFamily: 'Marriweather',
                              fontSize: 20,
                              color: Color(0xFF49454F),
                            )),
                        TextButton(
                            onPressed: () async {
                              final name = await _showDialog();
                              if (name == null || name.isEmpty) return;
                              setState(() => this.name = name);
                              _sendError(
                                  widget.infoGroup.name,
                                  widget.infoGroup.parameters[index],
                                  this.name);
                            },
                            child: const Text(
                              'Flag False Positive',
                              style: TextStyle(
                                color: Color.fromRGBO(134, 73, 33, 1.0),
                                fontFamily: 'Marriweather',
                              ),
                            )),
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
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
