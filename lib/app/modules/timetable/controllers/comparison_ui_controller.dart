import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:cui_timetable/app/data/database/database_constants.dart';

class ComparisonUiController extends GetxController {
  final TextEditingController textController = TextEditingController();
  var listVisible = true.obs;
  late final Box box;
  var teachers = [];
  var filteredList = [].obs;

  var respectiveSections =
      <String>[' '].obs; //! blank for the null section droplist
  var dropBoxValue = ' '.obs;
  @override
  Future<void> onInit() async {
    await fetchTeachers();
    box = await Hive.openBox(DBNames.teachersDB);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> fetchTeachers() async {
    final box = await Hive.openBox(DBNames.info);
    final list = box.get(DBInfo.teachers);
    teachers = list ?? [];
  }

  @override
  void onClose() {}
}
