import 'package:cui_timetable/app/modules/datesheet/teacher_datesheet/views/widgets/teacher_datesheet_widgets.dart';
import 'package:cui_timetable/app/theme/app_colors.dart';
import 'package:cui_timetable/app/theme/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';

import '../controllers/teacher_datesheet_controller.dart';

class TeacherDatesheetView extends GetView<TeacherDatesheetController> {
  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  final keys = ['10000', '1000', '100', '10', '1'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(Get.arguments[0]),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Obx((() => controller.isLoading.value
                      ? const SpinKitFadingCircle(
                          color: primaryColor,
                        )
                      : Row(children: [
                          ...List.generate(5, (index) {
                            return DayTile(
                              day: days[index].toString(),
                              dayKey: keys[index].toString(),
                              callback: controller.allFalse,
                              obs: controller.giveValue(index),
                            );
                          })
                        ])))),
            ),
            Flexible(
              flex: Constants.lectureFlex,
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: Padding(
                  padding: EdgeInsets.all(Constants.defaultPadding),
                  child: Obx(() => FractionallySizedBox(
                        widthFactor: 1,
                        heightFactor: 1,
                        child: controller.daywiseLectures.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const ImageIcon(
                                    AssetImage(
                                        'assets/timetable/free_lectures.png'),
                                    size: 150,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'No Duty Today',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w900,
                                          // fontSize:
                                        ),
                                  )
                                ],
                              ))
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: controller.daywiseLectures.length,
                                itemBuilder: (context, index) {
                                  // return Card(
                                  //   child: Text('hllleljasdlf'),
                                  // );
                                  return LectureDetailsTile(
                                    date: controller.daywiseLectures[index][1]
                                            .toString() +
                                        "-" +
                                        controller.daywiseLectures[index][2]
                                            .toString() +
                                        "-" +
                                        controller.daywiseLectures[index][3]
                                            .toString(),
                                    time: controller.daywiseLectures[index][4]
                                        .toString(),
                                    room: controller.daywiseLectures[index][5]
                                        .toString(),
                                    subject: controller.daywiseLectures[index]
                                            [7]
                                        .toString(),
                                    sections: controller.daywiseLectures[index]
                                            [6]
                                        .toString()
                                        .replaceAll("#", ", "),
                                  );
                                },
                              ),
                      )),
                ),
              ),
            ),
          ],
        ));
  }
}