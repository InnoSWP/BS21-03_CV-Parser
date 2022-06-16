import 'package:first_val_product/backend.dart';
import 'package:first_val_product/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class JsonHolderBox extends StatelessWidget {
  final CVInfoGroup infoGroup;
  const JsonHolderBox({required this.infoGroup, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      infoGroup.name,
    ));
  }
}
