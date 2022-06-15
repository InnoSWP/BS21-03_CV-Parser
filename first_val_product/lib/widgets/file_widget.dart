import 'package:first_val_product/backend.dart';
import 'package:first_val_product/main_page.dart';
import 'package:flutter/material.dart';

class FileWidget extends StatelessWidget {
  final CVInfo cvInfo;
  const FileWidget({required this.cvInfo, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.width * 0.11,
      width: MediaQuery.of(context).size.width * 0.08,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color.fromRGBO(73, 69, 79, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.only(left: 65),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: MediaQuery.of(context).size.width * 0.01,
                  color: const Color.fromRGBO(73, 69, 79, 1),
                ),
                onPressed: () => MainPage.instance.chooseCV(cvInfo),
              )),
          Container(
              child: Icon(Icons.insert_drive_file_outlined,
                  color: const Color.fromRGBO(77, 102, 88, 1),
                  size: MediaQuery.of(context).size.width * 0.05)),
          Container(
            padding: const EdgeInsets.only(left: 8),
            width: MediaQuery.of(context).size.width * 0.06,
            child: Text(
              cvInfo.fileName.split('.')[0],
              style: TextStyle(
                  color: const Color.fromRGBO(73, 69, 79, 1),
                  fontSize: MediaQuery.of(context).size.width * 0.006),
            ),
          )
        ],
      ),
    );
  }
}
