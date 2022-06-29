import 'dart:io';
import 'package:cv_parser/widgets/bottom_button_widget.dart';
import 'package:cv_parser/widgets/circular_progress_widget.dart';
import 'package:cv_parser/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:cv_parser/widgets/json_holder.dart';
import 'package:cv_parser/backend.dart';
import 'package:cv_parser/widgets/file_widget.dart';
import 'package:cv_parser/widgets/search_widget.dart';
import 'package:cv_parser/widgets/empty_widget.dart';

class MainPage extends StatefulWidget {
  static const int filesPerRow = 2;
  late bool change = false;
  late String toFind = '';
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

  void removeCV(
    CVInfo cvInfoToRemove,
    /*FileWidget file*/
  ) {
    if (currentCVInfo == cvInfoToRemove) {
      chooseCV(cvInfoToRemove);
    }
    allCVInfos.remove(cvInfoToRemove);
    //fileWidgets.remove(file);
    clearSearchBox();
    currentState.setState(() {});
  }

  void chooseCV(CVInfo cvInfo) {
    /* Color color;*/
    if (currentCVInfo == cvInfo) {
      currentCVInfo = null;
      displayWidget = const EmptyWidget();
      //print(file.colors.toString());
      /*color = Color(0xFF4D6658);*/
      //file?.colors= Color(0xFF4D6658);
    } else {
      currentCVInfo = cvInfo;
      displayWidget = JsonHolder(text: cvInfo.coolText);
      /*color = Colors.red;*/
      //file?.colors = Colors.red;
    }
    currentState.setState(() {});
  }

  void findCVsByParameter(String parameter) {
    shownCVInfos = [];
    var param = [];
    param = parameter.replaceAll(',', ' ').replaceAll(';', ' ').split(' ');
    change = true;
    toFind = parameter;
    for (var cvInfo in allCVInfos) {
      bool flag = true;
      for (int i = 0; i < param.length; i++) {
        if (!cvInfo.searchFor(param[i])) {
          flag = false;
        }
      }
      if (/*cvInfo.searchFor(parameter)*/ flag) {
        shownCVInfos.add(cvInfo);
      }
    }
    currentState.setState(() {});
  }

  void clearSearchBox() {
    change = false;
    toFind = '';
    shownCVInfos = [];
    shownCVInfos.addAll(allCVInfos);
    currentState.setState(() {});
  }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoading = false;

  SnackBar snackBarForAdding = const SnackBar(
    content: Text('Successfully added resume!'),
    duration: Duration(seconds: 1),
  );

  SnackBar snackBarForExportOne = const SnackBar(
    content: Text('Successfully exported resume!'),
    duration: Duration(seconds: 1),
  );

  SnackBar snackBarForExportAll = const SnackBar(
    content: Text('Successfully exported resumes!'),
    duration: Duration(seconds: 1),
  );

  SnackBar snackBarForDeletedResume = const SnackBar(
    content: Text('Resume has been deleted!'),
    duration: Duration(seconds: 1),
  );

  SnackBar snackBarForFlagging = const SnackBar(
    content: Text('Thank you for helping us develop!'),
    duration: Duration(seconds: 1),
  );

  void exportAll() async {
    print("Exporting ${widget.allCVInfos.length} CVs");
    for (var i = 0; i < widget.allCVInfos.length; i++) {
      await widget.shownCVInfos[i].export(postfix: "-$i");
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBarForExportAll);
  }

  void exportOne() async {
    print("Exporting $widget.currentCVInfo");
    await widget.currentCVInfo?.export(postfix: "");
    ScaffoldMessenger.of(context).showSnackBar(snackBarForExportOne);
  }

  void addResume() async {
    bool flag = false;
    print("Adding new CV");
    setState(() {
      isLoading = true;
    });
    List<CVInfo> newCVs = await getCVInfos();
    for (var cv in newCVs) {
      widget.currentCVInfo = cv;
      widget.allCVInfos.add(widget.currentCVInfo!);
      widget.displayWidget = JsonHolder(text: widget.currentCVInfo!.coolText);
      widget.fileWidgets.add(FileWidget(cvInfo: widget.currentCVInfo!));
      flag = true;
    }
    widget.clearSearchBox();
    setState(() {
      isLoading = false;
    });
    if (widget.fileWidgets.isNotEmpty && flag) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarForAdding);
    }
    widget.currentState.setState(() {});
  }

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
        backgroundColor: const Color(0xFFFBFDF7),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleWidget(),
                  isLoading
                      ? const Expanded(child: CircularWidget())
                      : Expanded(child: widget.displayWidget),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SearchWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(20.0),
                          padding: const EdgeInsets.all(5),
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          /*child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.3,*/
                          child: fileWidgetHolderChildren.isEmpty
                              ? (widget.allCVInfos.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No Uploaded Resumes ',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Color(0xFF49454F),
                                          fontFamily: 'Marriweather',
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: const Center(
                                        child: Text(
                                          'No results',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Color(0xFF49454F),
                                            fontFamily: 'Marriweather',
                                          ),
                                        ),
                                      ),
                                    ))
                              : SingleChildScrollView(
                                  controller: ScrollController(
                                      //initialScrollOffset: 40,
                                      //keepScrollOffset: false
                                      ),
                                  scrollDirection: Axis.vertical,
                                  child: widget.change
                                      ? Column(
                                          children: [
                                            Text(
                                              'The Query "' +
                                                  widget.toFind +
                                                  '" Found:',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF49454F),
                                                fontFamily: 'Marriweather',
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    fileWidgetHolderChildren)
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              fileWidgetHolderChildren))) /*SizedBox(
                            height: MediaQuery.of(context).size.width * 0.3,
                            child: SingleChildScrollView(
                                controller: ScrollController(
                                    //initialScrollOffset: 40,
                                    //keepScrollOffset: false
                                    ),
                                scrollDirection: Axis.vertical,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: fileWidgetHolderChildren)))*/
                      ),
                  /*),*/
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
                  // widget.addResume();
                  addResume();
                  setState(() {});
                }),
            BottomButtonWidget(
                text: "Export", onPressed: exportOne /*widget.exportOne*/),
            BottomButtonWidget(
                text: "Export All", onPressed: exportAll /*widget.exportAll*/),
          ],
        ));
  }
}
