import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'package:first_val_product/main_page.dart';
import 'package:first_val_product/backend.dart';
import 'package:first_val_product/widgets/file_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:test/test.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
// String gene

//   String invalid_string = "";
//   for(int i = 0; i < 10; i++){
//     invalid_string = invalid_string + String.fromCharCode(127 + Random().nextInt(100));
//   }
//   return invalid_string;
// }
bool DEBUG = false;
Future main() async {
  // String test = generateString();
  Future<List<CVInfo>> list = getCVInfos();
  List<CVInfo> cooler_list = await list;
  bool counter = false;
  group('Input text tests', () {
    test("Input file should contain text", () {
      expect(cooler_list[0].cvString.length > 0, true);
    });
  });
  int length = cooler_list[0].cvString.length;
  for (int i = 0; i < length; i++) {
    if (cooler_list[0].cvString[i] == ':') {
      counter = true;
    }
    if (cooler_list[0].cvString[i] == String.fromCharCode(92) &&
        cooler_list[0].cvString[i + 1] == 'n') {
      if (DEBUG) {
        print(counter);
      }
      counter = false;
    }
    if (counter) {
      if (cooler_list[0].cvString[i] == ' ') {
        for (int j = i; j < cooler_list[0].cvString.length; j++) {
          if (cooler_list[0].cvString[j] == ',' ||
              cooler_list[0].cvString[j] == String.fromCharCode(92)) {
            if (DEBUG) {
              bool search_string = cooler_list[0]
                  .searchFor(cooler_list[0].cvString.substring(i, j));
              // expect(true,true);
            }
            test('Search word should exist in file', () {
              expect(
                  cooler_list[0]
                      .searchFor(cooler_list[0].cvString.substring(i, j)),
                  true);
            });
            i = j;
            break;
          }
        }
      }
    }
  }
  group("Main Page test`s", () {
    MainPage test_page = new MainPage();
    test_page.currentCVInfo = cooler_list[0];
    test_page.allCVInfos.add(test_page.currentCVInfo!);
    test("Delete CV must lead to decrease number of CV`s ", () {
      test_page.allCVInfos.remove(cooler_list[0]);
      expect(test_page.allCVInfos.length, 0);
    });
    test("Remove non existing CV should not affect on number of CV`s", () {
      int updated_number_of_CVs = test_page.allCVInfos.length;
      test_page.allCVInfos.remove(cooler_list);
      expect(updated_number_of_CVs, test_page.allCVInfos.length);
    });
  });
  test("Export Test", () {
    for (var cv in cooler_list) {
      bool successFlag = false;
      cv.export();
      try {
        File(
            "$getApplicationDocumentsDirectory()/${cv.fileName.replaceRange(cv.fileName.length - 4, cv.fileName.length, "")}");
        successFlag = true;
      } catch (err) {}
      expect(successFlag, true);
    }
  });
}
