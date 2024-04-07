import 'package:finalprojectbarber/model/barber_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventItem extends StatelessWidget {
  final WorkSchedule event;
  final Function() onDelete;
  final Function()? onTap;
  const EventItem({
    Key? key,
    required this.event,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "เวลา ${DateFormat('HH:mm').format(event.workScheduleStartDate)} น. - ${DateFormat('HH:mm').format(event.workScheduleEndDate)} น.",
      ),
      subtitle: Text(
        event.workScheduleNote,
      ),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
