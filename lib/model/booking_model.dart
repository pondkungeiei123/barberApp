import 'package:finalprojectbarber/model/customer_model.dart';

import 'hair_model.dart';

class BookingModel {
  BookingInfo booking;
  LocationInfo location;
  CustomerInfo customer;
  HairModel hair;
  DateTime workScheduleStartDate;
  DateTime workScheduleEndDate;

  BookingModel(
      {required this.booking,
      required this.location,
      required this.customer,
      required this.hair,
      required this.workScheduleStartDate,
      required this.workScheduleEndDate});
}

class BookingInfo {
  final String bookingId;
  final String customerId;
  final String locationId;
  final DateTime startTime;
  final DateTime endTime;
  final int bookingStatus;
  final String hairId;
  final String workScheduleId;
  final int bookingPrice;

  const BookingInfo({
    required this.bookingId,
    required this.locationId,
    required this.customerId,
    required this.bookingStatus,
    required this.hairId,
    required this.startTime,
    required this.endTime,
    required this.workScheduleId,
    required this.bookingPrice,
  });
}
