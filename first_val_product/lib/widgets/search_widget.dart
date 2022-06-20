import 'package:first_val_product/main_page.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  void clearSearchBox() {
    MainPage.instance.clearSearchBox();
    _controller.clear();
  }

  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(0.1),
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.width * 0.022,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(251, 253, 247, 1),
        border:
            Border.all(width: 1, color: const Color.fromRGBO(73, 69, 79, 1)),
      ),
      child: Center(
        child: TextField(
          controller: _controller,
          onSubmitted: (s) => MainPage.instance.findCVsByParameter(s),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: MediaQuery.of(context).size.width * 0.016,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: MediaQuery.of(context).size.width * 0.013,
                ),
                onPressed: clearSearchBox,
              ),
              hintText: 'Search...',
              border: InputBorder.none),
        ),
      ),
    );
  }
}