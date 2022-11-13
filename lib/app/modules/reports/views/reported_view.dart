import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_timetable/app/modules/reports/controllers/reports_controller.dart';
import 'package:cui_timetable/app/theme/app_constants.dart';
import 'package:cui_timetable/app/widgets/get_widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';

class ReportedView extends GetView<ReportsController> {
  const ReportedView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.getReports(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data()!;
            final keys = data.keys.toList();

            keys.sort((a, b) {
              //sorting in ascending order
              return DateTime.parse(b).compareTo(DateTime.parse(a));
            });

            return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: Constants.defaultElevation,
                    child: Padding(
                      padding: EdgeInsets.all(Constants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data[keys[index]]["userTitle"],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w900),
                              ),
                              Text(
                                DateFormat("yyyy-MM-dd").format(
                                    DateTime.parse(keys[index].toString())),
                                // keys[index].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Constants.defaultPadding,
                          ),
                          Wrap(
                            children: [
                              Text(data[keys[index]]["userMSg"],
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            GetXUtilities.snackbar(
                title: "Error!",
                message: 'An error occured!',
                gradient: errorGradient);
          }
          return const Center(
            child: Text(
              'No Reports/Feedbacks available',
              style: TextStyle(fontSize: 20),
            ),
          );
        });
  }
}