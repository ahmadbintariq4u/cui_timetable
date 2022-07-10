import 'package:cui_timetable/app/data/database/timetable_db/timetable_database.dart';
import 'package:cui_timetable/app/widgets/global_widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:cui_timetable/app/data/database/database_constants.dart';
import 'package:cui_timetable/app/modules/timetable/controllers/student_ui_controller.dart';
import 'package:cui_timetable/app/routes/app_pages.dart';
import 'package:cui_timetable/app/theme/app_colors.dart';
import 'package:cui_timetable/app/theme/app_constants.dart';
import 'package:cui_timetable/app/widgets/get_widgets.dart';

class StudentUIView extends GetView<StudentUIController> {
  const StudentUIView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: EdgeInsets.all(Constants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(context),
              SizedBox(
                height: Constants.defaultPadding,
              ),
              _buildButton(context),
              ElevatedButton(
                  onPressed: () async {
                    final database = TimetableDatabase();
                    await database.createDatabase();
                  },
                  child: Text('Test Me'))
            ],
          ),
        ));
  }

// Build the textfield portion.
  Card _buildTextField(context) {
    var height = MediaQuery.of(context).size.height / 4;
    return Card(
      color: widgetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.defaultRadius),
      ),
      elevation: Constants.defaultElevation,
      shadowColor: shadowColor,
      child: Padding(
        padding: EdgeInsets.all(Constants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Constants.defaultPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => controller.searchBy["section"] == true
                      ? Text(
                          'Section Name',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          'Select Section',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                ),

                GestureDetector(
                  onTap: () async {
                    final box = await Hive.openBox(DBNames.history);
                    final List result =
                        box.get(DBHistory.studentTimetable, defaultValue: []);
                    controller.dialogHistoryList.value = result;
                    GetXUtilities.historyDialog(
                        context: context, content: result, student: true);
                  },
                  child: Container(
                    // color: Colors.red,
                    padding: EdgeInsets.symmetric(
                        horizontal: Constants.defaultPadding / 2,
                        vertical: Constants.defaultPadding / 3),
                    // color: Colors.red,
                    child: Icon(
                      Icons.history,
                      size: Constants.iconSize + 2,
                      color: primaryColor,
                    ),
                  ),
                ),

                //   ],
                // )
              ],
            ),
            SizedBox(
              height: Constants.defaultPadding,
            ),
            Obx(() => controller.searchBy["section"] == true
                ? TextFormField(
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    controller: controller.textController,
                    onChanged: (value) {
                      controller.filteredList.value = controller.sections
                          .where((element) => element
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();

                      if (value.isEmpty || value.isEmpty) {
                        controller.listVisible.value = false;
                        controller.filteredList.clear();
                      } else if (controller.filteredList.contains(value) &&
                          controller.filteredList.length == 1) {
                        controller.listVisible.value = false;
                      } else {
                        controller.listVisible.value = true;
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller.textController.clear();
                            controller.filteredList.value = [];
                          },
                          icon: const Icon(Icons.cancel, color: primaryColor)),
                      fillColor: textFieldColor,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Constants.defaultRadius),
                          borderSide: const BorderSide(color: primaryColor)),
                    ))
                : Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Constants.defaultPadding,
                              vertical: Constants.defaultPadding / 2),
                          decoration: BoxDecoration(
                              color: textFieldColor,
                              borderRadius: BorderRadius.circular(
                                  Constants.defaultRadius)),
                          child: DropdownButton<dynamic>(
                            focusColor: textFieldColor,
                            isExpanded: true,
                            borderRadius: BorderRadius.all(
                                Radius.circular(Constants.defaultRadius)),
                            dropdownColor: widgetColor,
                            style: Theme.of(context).textTheme.titleMedium,
                            underline: Container(
                              height: 2,
                              color: primaryColor,
                            ),
                            value: controller.yearTokenSelected.value,
                            items: controller.yearTokens
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      // textAlign: TextAlign.center,
                                    )))
                                .toList(),
                            onChanged: (value) {
                              controller.yearTokenSelected.value = value;
                              // debugPrint(_);
                              controller.changeSectionTokens(value);
                              // con
                            },
                          ),
                        ),
                      ),
                      kWidth,
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Constants.defaultPadding,
                              vertical: Constants.defaultPadding / 2),
                          decoration: BoxDecoration(
                              color: textFieldColor,
                              borderRadius: BorderRadius.circular(
                                  Constants.defaultRadius)),
                          child: DropdownButton<dynamic>(
                            focusColor: textFieldColor,
                            isExpanded: true,
                            borderRadius: BorderRadius.all(
                                Radius.circular(Constants.defaultRadius)),
                            dropdownColor: widgetColor,
                            style: Theme.of(context).textTheme.titleMedium,
                            underline: Container(
                              height: 2,
                              color: primaryColor,
                            ),
                            value: controller.sectionTokenSelected.value,
                            items: controller.sectionTokens
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) {
                              controller.sectionTokenSelected.value = value;

                              controller.changeSectionVariantsTokens(value);
                            },
                          ),
                        ),
                      ),
                      kWidth,
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Constants.defaultPadding,
                              vertical: Constants.defaultPadding / 2),
                          decoration: BoxDecoration(
                              color: textFieldColor,
                              borderRadius: BorderRadius.circular(
                                  Constants.defaultRadius)),
                          child: DropdownButton<dynamic>(
                            focusColor: textFieldColor,
                            isExpanded: true,
                            borderRadius: BorderRadius.all(
                                Radius.circular(Constants.defaultRadius)),
                            dropdownColor: widgetColor,
                            style: Theme.of(context).textTheme.titleMedium,
                            underline: Container(
                              height: 2,
                              color: primaryColor,
                            ),
                            value:
                                controller.sectionVariantsTokenSelected.value,
                            items: controller.sectionVariantsTokens
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (_) {
                              controller.sectionVariantsTokenSelected.value = _;
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
            SizedBox(
              height: Constants.defaultPadding / 2,
            ),
            Obx(() => controller.filteredList.isEmpty
                ? const SizedBox()
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                      maxHeight: controller.listVisible.value ? height : 0,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.filteredList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            controller.textController.text =
                                controller.filteredList[index];
                            controller.textController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset:
                                        controller.textController.text.length));
                            controller.listVisible.value = false;
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Text(
                            controller.filteredList[index],
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: primaryColor,
                          height: 2,
                          // indent: 15,
                          // endIndent: 15,
                        );
                      },
                    ),
                  ))
          ],
        ),
      ),
    );
  }

// Build the button portion.
  Padding _buildButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: IntrinsicWidth(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
            onPressed: () async {
              var value;
              if (controller.searchBy["section"] == true) {
                value = controller.textController.text.toString();

                if (controller.sections.contains(value)) {
                  // Storing the information for state persistency

                  // final box2 = await Hive.openBox(DBNames.history);
                  // List list =
                  //     box2.get(DBHistory.studentTimetable, defaultValue: []);
                  // if (list.length != 6) {
                  //   Set result = list.toSet();
                  //   result.add(value);
                  //   box2.put(DBHistory.studentTimetable, result.toList());
                  //   // await box2.close();
                  // }
                  List tokens = value.split("-");
                  var result = "";
                  for (var i = 2; i < tokens.length; i++) {
                    result += tokens[i];
                    if (i != tokens.length - 1) {
                      result += '-';
                    }
                  }
                  _cacheData(
                      value: value,
                      yearToken: tokens[0].trim(),
                      sectionToken: tokens[1].trim(),
                      sectionVariantToken: result.trim());
                  Get.toNamed(Routes.STUDENT_TIMETABLE, arguments: [value]);
                } else {
                  GetXUtilities.snackbar(
                      title: 'Not Found!!',
                      message: 'Enter Valid Section Name',
                      gradient: primaryGradient);
                }
              } else {
                value =
                    "${controller.yearTokenSelected.value}-${controller.sectionTokenSelected.value}";
                if (controller.sectionVariantsTokenSelected.value != '') {
                  value =
                      "$value-${controller.sectionVariantsTokenSelected.value}";
                }

                _cacheData(
                    value: value,
                    yearToken: controller.yearTokenSelected.value,
                    sectionToken: controller.sectionTokenSelected.value,
                    sectionVariantToken:
                        controller.sectionVariantsTokenSelected.value);

                Get.toNamed(Routes.STUDENT_TIMETABLE, arguments: [value]);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(Constants.defaultPadding),
              child: Padding(
                padding: EdgeInsets.all(Constants.defaultPadding),
                child: Text('Find Now',
                    style: Theme.of(context).textTheme.labelLarge
                    // .copyWith(fontSize: 16),
                    ),
              ),
            )),
      ),
    );
  }

  _cacheData(
      {required String value,
      required yearToken,
      required sectionToken,
      required sectionVariantToken}) async {
    final box1 = await Hive.openBox(DBNames.timetableCache);
    await box1.put(DBTimetableCache.studentSection, value);

    // storing the list information
    await box1.put(DBTimetableCache.studentYearToken, yearToken);

    await box1.put(DBTimetableCache.studentSecToken, sectionToken);

    await box1.put(DBTimetableCache.studentSecVToken, sectionVariantToken);
  }
}
