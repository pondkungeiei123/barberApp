// ignore_for_file: use_build_context_synchronously

import 'package:finalprojectbarber/model/hair_model.dart';
import 'package:finalprojectbarber/screen/booking_add_details_screen.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import '../model/barber_model.dart';
import '../php_data/php_data.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';
import 'show_workings.dart';

class WorkScheduleDetailScreen extends StatefulWidget {
  final WorkScheduleModel model;

  const WorkScheduleDetailScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkScheduleDetailScreenState createState() =>
      _WorkScheduleDetailScreenState();
}

class _WorkScheduleDetailScreenState extends State<WorkScheduleDetailScreen> {
  late WorkScheduleModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
    _getHairs();
  }

  _getHairs() async {
    await getAllHairs(context);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<HairModel> hairList =
        Provider.of<DataManagerProvider>(context, listen: false).getAllHairs;
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: AppTheme.fullHeight(context),
            child: DraggableScrollableSheet(
              maxChildSize: 1.0,
              minChildSize: 1.0,
              initialChildSize: 1.0,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.only(
                    left: 19,
                    right: 19,
                    top: 16,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const BackButton(
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Text(
                                    "รายละเอียด",
                                    style: titleStyle.copyWith(
                                        color: Colors.black),
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 5,
                                // ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "${model.barber.barberFirstName} ${model.barber.barberLastName}",
                                  style: TextStyles.bodySm.subTitleColor.bold,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  model.workSchedule.workScheduleStatus == 0
                                      ? "ว่าง"
                                      : "ไม่ว่าง",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color:
                                        model.workSchedule.workScheduleStatus ==
                                                0
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: .3,
                            color: LightColor.grey,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 45,
                            // width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: LightColor.grey.withAlpha(150),
                            ),
                            child: const Text("ดูผลงานช่าง"),
                          ).ripple(
                            () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ShowWorkingsPage(id: model.barber.barberId),
                              ));
                            },
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Text("ระยะเวลา", style: titleStyle).vP16,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  " วันที่ ${DateFormat.MMMMd('th-TH').format(model.workSchedule.workScheduleStartDate)}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.timer_rounded,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  " เวลา ${DateFormat('HH:mm').format(model.workSchedule.workScheduleStartDate)} น. - ${DateFormat('HH:mm').format(model.workSchedule.workScheduleEndDate)} น.",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Text("ที่อยู่", style: titleStyle).vP16,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  model.barber.barberNamelocation,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          Text("เลือกทรงผม", style: titleStyle).vP8,
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: hairList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                              childAspectRatio: 2.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              HairModel hair = hairList[index];
                              return Card.outlined(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                BookingAddDetailScreen(
                                                  model: model,
                                                  hairModel: hairList[index],
                                                )));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //  ClipRRect(
                                      //   borderRadius: const BorderRadius.vertical(
                                      //       top: const Radius.circular(10.0)),
                                      //   child: Image.asset(
                                      //   "assets/barber.png",
                                      //   fit: BoxFit.cover,
                                      //   width: double.infinity,
                                      //   height: 100.0, // Adjust this value as needed
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              hair.hairName,
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              '${hair.hairPrice.toString()} บาท',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // SizedBox(
                          //   height: 202, // Adjust the height as needed
                          //   child: CustomScrollView(
                          //     slivers: <Widget>[
                          //       SliverGrid(
                          //         gridDelegate:
                          //             const SliverGridDelegateWithFixedCrossAxisCount(
                          //           crossAxisCount: 2,
                          //           crossAxisSpacing: 5,
                          //           mainAxisSpacing: 5,
                          //         ),
                          //         delegate: SliverChildBuilderDelegate(
                          //           (context, index) {
                          //             return getShowHairWidgetList(
                          // Provider.of<DataManagerProvider>(
                          //         context,
                          //         listen: false)
                          //     .getAllHairs,
                          //                 index,
                          //                 context);
                          //           },
                          //           childCount:
                          //               Provider.of<DataManagerProvider>(
                          //                       context,
                          //                       listen: false)
                          //                   .getAllHairs
                          //                   .length,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          const SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ).vP16),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
