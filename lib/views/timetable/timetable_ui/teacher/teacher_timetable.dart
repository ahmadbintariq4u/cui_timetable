import 'package:cui_timetable/controllers/timetable/teacher/teacher_timetable_controller.dart';
import 'package:cui_timetable/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class TeacherTimetable extends StatelessWidget {
  TeacherTimetable({Key? key}) : super(key: key);
  final teacherTimetableController = Get.put(TeacherTimetableController());
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
                    stream: teacherTimetableController.openBox(
                        teacher: arguments[0]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const GFLoader();
                      } else {
                        return Row(children: [
                          ...List.generate(5, (index) {
                            return DayTile(
                              controller: teacherTimetableController,
                              day: days[index],
                              dayKey: keys[index],
                              callback: teacherTimetableController.allFalse,
                              obs: teacherTimetableController.giveValue(index),
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
                    child: teacherTimetableController.daywiseLectures.isEmpty
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
                            itemCount: teacherTimetableController
                                .daywiseLectures.length,
                            itemBuilder: (context, index) {
                              return LectureDetailsTile(
                                section: teacherTimetableController
                                    .daywiseLectures[index][0],
                                subject: teacherTimetableController
                                    .daywiseLectures[index][1],
                                room: teacherTimetableController
                                    .daywiseLectures[index][4],
                                time: teacherTimetableController.timeMap[
                                    "${teacherTimetableController.daywiseLectures[index][2]}"],
                              );
                            },
                          ),
                  )),
            ),
          ],
        ));
  }
}

class DayTile extends StatelessWidget {
  late final TeacherTimetableController controller;
  late final day;
  late final dayKey;
  late final callback;

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

  DayTile(
      {required this.day,
      required this.dayKey,
      required this.callback,
      required this.obs,
      Key? key,
      required this.controller})
      : super(key: key);

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
                          Text(day),
                          controller.lecturesCount[dayKey] == "null"
                              ? const GFLoader()
                              : Text(
                                  controller.lecturesCount[dayKey].toString()),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              ...List.generate(
                                  int.parse(controller
                                      .lecturesCount[dayKey.toString()]
                                      .toString()),
                                  (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
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
                    color: Colors.transparent,
                  ),
                ))),
          )),
    );
  }
}

class LectureDetailsTile extends StatelessWidget {
  late final time;
  late final subject;
  late final room;
  late final section;

  LectureDetailsTile(
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          // fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('|'),
                    const Text('|'),
                    Text(
                      time[1],
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          // fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
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
                                  .copyWith(fontStyle: FontStyle.italic),
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
