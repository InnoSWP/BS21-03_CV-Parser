import 'package:flutter/material.dart';
class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(2),
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.width * 0.02,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(251, 253, 247, 1),
        border: Border.all(
            width: 1, color: const Color.fromRGBO(73, 69, 79, 1)),
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(
          size: MediaQuery.of(context).size.width * 0.015,
          Icons.search,
          color: const Color.fromRGBO(73, 69, 79, 1),
        ),
        label: Text(
          'search',
          style: TextStyle(
            color: const Color.fromRGBO(73, 69, 79, 1),
            fontFamily: 'Marriweather',
            fontSize: MediaQuery.of(context).size.width * 0.01,
          ),
        ),
        style: ButtonStyle(
          shape:
          MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          //minimumSize: MaterialStateProperty.all(const Size(140, 50)),
          backgroundColor:
          MaterialStateProperty.all(Colors.transparent),
          shadowColor:
          MaterialStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }
}
