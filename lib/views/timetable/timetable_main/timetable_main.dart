import 'package:cui_timetable/style.dart';
import 'package:cui_timetable/views/timetable/timetable_main/student_ui.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Timetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            buildAppBar(context),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  StudentUI(),

                  // main container

                  const Icon(Icons.directions_transit),
                  const Icon(Icons.directions_bike),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(context) {
    return SliverAppBar(
        title: const Text('Timetable'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: defaultPadding),
            child: Icon(
              Icons.search,
            ),
          )
        ],
        bottom: TabBar(
          indicatorPadding: const EdgeInsets.all(defaultPadding / 3),
          indicatorWeight: 4,
          indicatorColor: shadowColor,
          tabs: [
            Tab(
                child: Text(
              'Student',
              style: Theme.of(context).textTheme.labelLarge,
            )),
            Tab(
                child: Text(
              'Teacher',
              style: Theme.of(context).textTheme.labelLarge,
            )),
            Tab(
                child: Text(
              'Compare',
              style: Theme.of(context).textTheme.labelLarge,
            )),
          ],
        ));
  }
}
