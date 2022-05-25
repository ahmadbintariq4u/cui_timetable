import 'package:get/get.dart';

import '../modules/freerooms/bindings/freerooms_binding.dart';
import '../modules/freerooms/views/freerooms_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/sync/bindings/sync_binding.dart';
import '../modules/sync/views/sync_view.dart';
import '../modules/timetable/bindings/timetable_binding.dart';
import '../modules/timetable/student_timetable/bindings/student_timetable_binding.dart';
import '../modules/timetable/student_timetable/views/student_timetable_view.dart';
import '../modules/timetable/teacher_timetable/bindings/teacher_timetable_binding.dart';
import '../modules/timetable/teacher_timetable/views/teacher_timetable_view.dart';
import '../modules/timetable/views/timetable_view.dart';
import '../modules/ui/about_us/about_us_view.dart';
import '../modules/ui/director_vision/director_vision.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_US,
      page: () => const AboutUsView(),
    ),
    GetPage(
      name: _Paths.DIRECTOR_VISION,
      page: () => const DirectorVisionView(),
    ),
    GetPage(
      name: _Paths.TIMETABLE,
      page: () => TimetableView(),
      binding: TimetableBinding(),
      children: [
        GetPage(
          name: _Paths.STUDENT_TIMETABLE,
          page: () => StudentTimetableView(),
          binding: StudentTimetableBinding(),
        ),
        GetPage(
          name: _Paths.TEACHER_TIMETABLE,
          page: () => TeacherTimetableView(),
          binding: TeacherTimetableBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SYNC,
      page: () => const SyncView(),
      binding: SyncBinding(),
    ),
    GetPage(
      name: _Paths.FREEROOMS,
      page: () => FreeroomsView(),
      binding: FreeroomsBinding(),
    ),
  ];
}