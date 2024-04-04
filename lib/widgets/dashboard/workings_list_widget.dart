import 'package:finalprojectbarber/model/workings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../workings_tile.dart';

// ignore: non_constant_identifier_names
Widget WorkingsList(List<WorkingsModel> workings, BuildContext context) {
  return SliverGrid(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
    ),
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        return getWorkingsWidgetList(workings, index, context);
      },
      childCount: workings.length,
    ),
  );
}

Widget getWorkingsWidgetList(
    List<WorkingsModel> workingsDataList, int index, BuildContext context) {
  return Container(
    child: workingsTile(workingsDataList[index], index, context),
  );
}
