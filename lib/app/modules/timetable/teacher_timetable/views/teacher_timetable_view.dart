import 'package:cui_timetable/app/modules/timetable/teacher_timetable/controllers/teacher_timetable_controller.dart';
import 'package:cui_timetable/app/theme/app_colors.dart';
import 'package:cui_timetable/app/theme/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class TeacherTimetableView extends GetView<TeacherTimetableController> {
  TeacherTimetableView({Key? key}) : super(key: key);
  // final teacherTimetableController = Get.put(TeacherTimetableController());

  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  final keys = ['10000', '1000', '100', '10', '1'];
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    return Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(Get.arguments[0]),
          // actions: [
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          // ],
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: StreamBuilder(
                    stream: controller.openBox(teacher: arguments[0]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SpinKitFadingCircle(
                          size: 50,
                          color: primaryColor,
                        );
                      } else {
                        return Row(children: [
                          ...List.generate(5, (index) {
                            return DayTile(
                              day: days[index],
                              dayKey: keys[index],
                              callback: controller.allFalse,
                              obs: controller.giveValue(index),
                            );
                          })
                        ]);
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            Flexible(
              flex: 6,
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
                                'No Lecture Today',
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
                              return LectureDetailsTile(
                                section: controller.daywiseLectures[index][0],
                                subject: controller.daywiseLectures[index][1],
                                room: controller.daywiseLectures[index][5],
                                time: controller.timeMap[
                                    "${controller.daywiseLectures[index][2]}"],
                              );
                            },
                          ),
                  )),
            ),
          ],
        ));
  }
}

class DayTile extends GetView<TeacherTimetableController> {
  // late final TeacherTimetableController controller;
  late final String day;
  late final String dayKey;
  late final Function callback;

  late final Rx<bool> obs;
  final colorList = [
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.black,
    Colors.orange,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.black,
    Colors.orange,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.black,
    Colors.orange,
  ];

  DayTile({
    required this.day,
    required this.dayKey,
    required this.callback,
    required this.obs,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          heightFactor: 1,
          widthFactor: 1,
          child: Padding(
            padding: const EdgeInsets.only(
                left: defaultPadding / 2, right: defaultPadding / 2),
            child: Obx(() => Card(
                color: widgetColor,
                shadowColor: shadowColor,
                elevation: obs.value ? defaultElevation : defaultElevation / 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                      color: obs.value ? selectionColor : widgetColor,
                      borderRadius: BorderRadius.circular(defaultRadius)),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(defaultRadius),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(defaultRadius),
                      onTap: () {
                        callback();
                        controller.getLectures(key: dayKey.toString());
                        obs.value = true;
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(day,
                              style: Theme.of(context).textTheme.titleMedium),
                          controller.lecturesCount[dayKey] == "null"
                              ? const SpinKitFadingCircle(
                                  size: 50,
                                  color: primaryColor,
                                )
                              : Text(
                                  controller.lecturesCount[dayKey].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                          int.parse(controller.lecturesCount[dayKey.toString()]
                                      .toString()) ==
                                  0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 2),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: successGradient)),
                                  ),
                                )
                              : Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    ...List.generate(
                                        int.parse(controller
                                            .lecturesCount[dayKey.toString()]
                                            .toString()),
                                        (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              child: Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                    color: colorList[index],
                                                    shape: BoxShape.circle),
                                              ),
                                            ))
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ))),
          )),
    );
  }
}

class LectureDetailsTile extends StatelessWidget {
  final dynamic time;
  final String subject;
  final String room;
  final String section;

  const LectureDetailsTile(
      {Key? key,
      required this.subject,
      required this.section,
      required this.room,
      this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 4),
      child: Card(
        color: widgetColor,
        elevation: defaultElevation,
        shadowColor: shadowColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time[0],
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Text('|'),
                    const Text('|'),
                    Text(
                      time[1],
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const VerticalDivider(
                  color: primaryColor,
                  thickness: 2.0,
                  // indent: 4,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: textFieldColor,
                              borderRadius:
                                  BorderRadius.circular(defaultRadius)),
                          child: Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Text(
                              subject.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const ImageIcon(
                              AssetImage('assets/home/room.png'),
                              color: primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              room.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const ImageIcon(
                              AssetImage('assets/timetable/professor.png'),
                              color: primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              section.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
