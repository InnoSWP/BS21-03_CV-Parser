import 'package:cv_parser/backend.dart';
import 'package:cv_parser/main_page.dart';
import 'package:flutter/material.dart';

import 'json_holder.dart';

class FileWidget extends StatefulWidget {
  final CVInfo cvInfo;
  const FileWidget({required this.cvInfo, Key? key}) : super(key: key);

  @override
  State<FileWidget> createState() => _FileWidgetState();
  //late State<FileWidget> currentState;
}

class _FileWidgetState extends State<FileWidget> {
  @override
  Widget build(BuildContext context) {
    bool flag = MainPage.instance.currentCVInfo == widget.cvInfo;
    this.setState(() {
      flag = MainPage.instance.currentCVInfo == widget.cvInfo;
    });
    return Container(
      padding: const EdgeInsets.all(5),
      height: 180,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color.fromRGBO(73, 69, 79, 1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 20,
            color: Colors.transparent,
            alignment: Alignment.topRight,
            child: IconButton(
              iconSize: 18,
              splashRadius: 9,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              icon: const Icon(
                Icons.close,
                color: Color.fromRGBO(73, 69, 79, 1),
                size: 18,
              ),
              onPressed: () => MainPage.instance.removeCV(widget.cvInfo),
            ),
          ),
          Container(
            width: double.infinity,
            height: 118,
            child: IconButton(
              //autofocus: true,
              splashRadius: 65,
              onPressed: () => {
                MainPage.instance.chooseCV(widget.cvInfo),
                setState(() {
                  flag = (MainPage.instance.currentCVInfo == widget.cvInfo);
                })
              },
              icon: Icon(Icons.insert_drive_file_outlined,
                  color: flag
                      ? Color.fromRGBO(134, 73, 33, 1.0)
                      : Color.fromRGBO(77, 102, 88, 1),
                  size: 100),
            ),
          ),
          Container(
            width: double.infinity,
            height: 30,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              widget.cvInfo.fileName.split('.')[0],
              style: const TextStyle(
                  color: Color.fromRGBO(73, 69, 79, 1),
                  fontFamily: 'Marriweather',
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
