import 'dart:io';
import 'package:first_val_product/widgets/bottom_button_widget.dart';
import 'package:first_val_product/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_val_product/widgets/json_holder.dart';
import 'package:first_val_product/backend.dart';
import 'package:first_val_product/widgets/file_widget.dart';
import 'package:first_val_product/widgets/search_widget.dart';
import 'package:first_val_product/widgets/empty_widget.dart';

class MainPage extends StatefulWidget {
  static const int filesPerRow = 2;
  static late MainPage instance;
  late State<MainPage> currentState;
  CVInfo? currentCVInfo;
  late List<CVInfo> allCVInfos;
  late List<CVInfo> shownCVInfos;
  late List<FileWidget> fileWidgets;
  late Widget displayWidget;
  MainPage({Key? key}) : super(key: key) {
    instance = this;
    currentCVInfo = null;
    displayWidget = const EmptyWidget();
    allCVInfos = [];
    fileWidgets = [];
    shownCVInfos = [];
  }

  void removeCV(CVInfo cvInfoToRemove) {
    if (currentCVInfo == cvInfoToRemove) {
      chooseCV(cvInfoToRemove);
    }
    allCVInfos.remove(cvInfoToRemove);
    currentState.setState(() {});
  }

  void chooseCV(CVInfo cvInfo) {
    if (currentCVInfo == cvInfo) {
      currentCVInfo = null;
      displayWidget = const EmptyWidget();
    } else {
      currentCVInfo = cvInfo;
      displayWidget = JsonHolder(text: cvInfo.coolText);
    }
    currentState.setState(() {});
  }

  void addResume() async {
    print("Adding new CV");
    List<CVInfo> newCVs = await getCVInfos();
    for (var cv in newCVs) {
      currentCVInfo = cv;
      allCVInfos.add(currentCVInfo!);
      displayWidget = JsonHolder(text: currentCVInfo!.coolText);
      fileWidgets.add(FileWidget(cvInfo: currentCVInfo!));
    }
    clearSearchBox();
    currentState.setState(() {});
  }

  void exportOne() async {
    print("Exporting $currentCVInfo");
    await currentCVInfo?.export(postfix: "");
  }

  void exportAll() async {
    print("Exporting ${allCVInfos.length} CVs");
    for (var i = 0; i < allCVInfos.length; i++) {
      await currentCVInfo?.export(postfix: "-$i");
    }
  }

  void findCVsByParameter(String parameter) {
    shownCVInfos = [];
    for (var cvInfo in allCVInfos) {
      if (cvInfo.searchFor(parameter)) {
        shownCVInfos.add(cvInfo);
      }
    }
    currentState.setState(() {});
  }

  void clearSearchBox() {
    shownCVInfos = [];
    shownCVInfos.addAll(allCVInfos);
    currentState.setState(() {});
  }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    widget.currentState = this;
    List<Widget> fileWidgetHolderChildren = [];
    List<FileWidget> currentRowChildren = [];
    for (var i = 0; i < widget.shownCVInfos.length; i++) {
      currentRowChildren.add(FileWidget(cvInfo: widget.shownCVInfos[i]));
      if (i % MainPage.filesPerRow == MainPage.filesPerRow - 1) {
        fileWidgetHolderChildren.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: currentRowChildren,
        ));
        fileWidgetHolderChildren.add(const SizedBox(height: 20));
        currentRowChildren = [];
      }
    }
    if (widget.shownCVInfos.length % MainPage.filesPerRow > 0) {
      fileWidgetHolderChildren.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: currentRowChildren,
      ));
    }

    return Scaffold(
        backgroundColor: const Color.fromRGBO(251, 253, 247, 1),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWidget(),
                  Expanded(child: widget.displayWidget),
                ],
              ),
            ) /*)*/
            /*Expanded(
            child: jsonHolder,
          )*/
            ,
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SearchWidget(),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(5),
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.3,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: fileWidgetHolderChildren)))),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.03,
                  )
                ],
              ),
            ))
          ],
        ),
        floatingActionButton: Wrap(
          direction: Axis.horizontal,
          children: [
            BottomButtonWidget(
                text: "Add Resume",
                onPressed: () {
                  widget.addResume();
                  setState(() {});
                }),
            BottomButtonWidget(text: "Export", onPressed: widget.exportOne),
            BottomButtonWidget(text: "Export All", onPressed: widget.exportAll),
          ],
        ));
  }
}
