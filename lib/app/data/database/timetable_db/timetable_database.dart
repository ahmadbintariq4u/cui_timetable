import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import '../database_constants.dart';
import '../database_utilities_methods.dart';

class TimetableDatabase {
  // String search_section = '';

  Future<bool> createDatabase() async {
    await downloadFile(
      fileName: 'timetable.csv',
      callback: insertTimetableData,
    );
    return Future.value(true);
  }

  //! All the code run in working Isolate, Be aware

  Future<Future<int>> insertTimetableData(
      {required String filePath, required List<dynamic> data}) async {
    Hive.init(filePath); // initialize the data, bcz of their separate isolate.
    await deleteData();
    // fetch sections as well as teachers.
    final sections = <String>{};
    final teachers = <String>{};

    for (var item in data) {
      // debugPrint(item[0].trim().replaceAll(' ', '').replaceAll('?', '-'));
      // sections.add(item[0].trim().replaceAll(' ', '').replaceAll('?', '-'));
      sections.add(item[0].trim());
      teachers.add(item[4].trim());
    }

    //  =====  creating students database  ===== //
    final box1 = await Hive.openBox(DBNames.timetableData);
    Map<String, dynamic> result = {};
    for (var i in sections) {
      var lectures = data
          .toList()
          .where((element) =>
              element[0].toString().toLowerCase() == i.toLowerCase())
          .toList();
      result[i.toLowerCase()] = lectures;
    }
    await box1.put(DBTimetableData.studentsData, result);
    await Future.delayed(const Duration(milliseconds: 100));
    // await box1.close();

    //  =====  creating teachers database  ===== //
    // final box2 = await Hive.openBox(DBNames.teachersDB);
    result.clear();
    for (var i in teachers) {
      var lectures = data
          .toList()
          .where((element) =>
              element[4].toString().toLowerCase() == i.toLowerCase())
          .toList();
      result[i.toLowerCase()] = lectures;
      // result.add({i.toLowerCase(): lectures});
    }
    await box1.put(DBTimetableData.teachersData, result);
    await Future.delayed(const Duration(milliseconds: 100));
    // await box2.close();

    //  =====  storing  students and teachers list  ===== //
    // final box3 = await Hive.openBox(DBNames.info);
    await box1.put(DBTimetableData.sections, sections.toList());
    await box1.put(DBTimetableData.teachers, teachers.toList());
    await Future.delayed(const Duration(milliseconds: 200));

    await box1.close();

    // Hive.close();
    // final overallTokens = [];

    // final yearTokens = [];
    // final overall = [];
    // for (var element in sections) {
    //   final result = element.split("-");
    //   // debugPrint(result.toString());
    //   yearTokens.add(result[0]);
    //   // sectionTokens.add(result[1]);
    //   var value = "";
    //   for (var i = 2; i < result.length; i++) {
    //     value += result[i];
    //     if (i != result.length - 1) {
    //       value += '-';
    //     }
    //   }

    // //   overall.add([result[0], result[1], value]);
    // }
    // yearTokens.sort();
    // debugPrint(overall.toString());
    // // print(yearTokens.toSet());
    // final box = await Hive.openBox(DBNames.general);
    // await box.put(DBGeneral.yearTokens, yearTokens.toSet().toList());

    // await box.put(DBGeneral.overallTokens, overall.toSet().toList());
    // await box.put(DBGeneral.sectionTokens, sectionTokens.toSet().toList());
    // await box.put(DBGeneral.sectionVariantsTokens,
    //     sectionVariantsTokens.toSet().toList());

    // print(sections);
    return Future<int>.value(1);
  }

  Future<void> deleteData() async {
    var box = await Hive.openBox(DBNames.timetableData);
    await box.clear();
    await Future.delayed(const Duration(milliseconds: 50));
  }
}
