// ignore_for_file: non_constant_identifier_names

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screen/barber_booking_details_screen.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';


  

Widget BarberBookingTile(BookingModel model, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      boxShadow: <BoxShadow>[
        const BoxShadow(
          offset: Offset(4, 4),
          blurRadius: 10,
          color: Colors.black26,
        ),
        BoxShadow(
          offset: const Offset(-3, 0),
          blurRadius: 15,
          color: LightColor.grey.withOpacity(.1),
        )
      ],
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                "${model.customer.customerFirstName} ${model.customer.customerLastName}",
                style: TextStyles.titleM.bold
                    .copyWith(color: Colors.black, fontSize: 18.0),
              ),
              subtitle: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range,
                            size: 15,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "วันที่ ${DateFormat.MMMMd('th-TH').format(model.workScheduleStartDate)}",
                            style:
                                TextStyles.bodySm.subTitleColor.bold.copyWith(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_rounded,
                            size: 15,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "เวลา ${DateFormat('HH:mm').format(model.workScheduleStartDate)} น. - ${DateFormat('HH:mm').format(model.workScheduleEndDate)} น.",
                            style: TextStyles.bodySm.subTitleColor.bold
                                .copyWith(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.home,
                            size: 15,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            " ${model.location.locationName}",
                            style: TextStyles.bodySm.subTitleColor.bold
                                .copyWith(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "สถานะ : ",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            model.booking.bookingStatus == 0
                                ? "รอยืนยัน"
                                : "ไม่ว่าง",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: model.booking.bookingStatus == 0
                                  ? Colors.blue[400]
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    ).ripple(
      () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => BarBerBookingDetailScreen(model: model)));
      },
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
  );
}
