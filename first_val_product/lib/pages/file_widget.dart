import 'package:flutter/material.dart';
class FileWidget extends StatefulWidget {
  const FileWidget({Key? key}) : super(key: key);

  @override
  State<FileWidget> createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height:
      MediaQuery.of(context).size.width *
          0.11,
      width: MediaQuery.of(context).size.width *
          0.08,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color:
            const Color.fromRGBO(73, 69, 79, 1)),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [

          Container(
              padding: EdgeInsets.only(left: 65),
              child: IconButton(icon: Icon(Icons.close, size: MediaQuery.of(context)
                  .size
                  .width *
                  0.01,  color: Color.fromRGBO(73, 69, 79, 1),), onPressed: () {  },)
          ),
          Container(
              child: Icon(
                  Icons
                      .insert_drive_file_outlined,
                  color: const Color.fromRGBO(
                      77, 102, 88, 1),
                  size: MediaQuery.of(context)
                      .size
                      .width *
                      0.05)),
          Container(
            padding: const EdgeInsets.only(left: 8),
            width: MediaQuery.of(context)
                .size
                .width *
                0.06,
            child: Text(
              "yourFilek.aboba",
              style: TextStyle(
                  color: const Color.fromRGBO(
                      73, 69, 79, 1),
                  fontSize:
                  MediaQuery.of(context)
                      .size
                      .width *
                      0.006),
            ),
          )
        ],
      ),
    );
  }
}
