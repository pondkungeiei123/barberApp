class BarberInfo {
  final String barberId;
  final String barberFirstName;
  final String barberLastName;
  final String barberPhone;
  final String barberEmail;
  final String barberPassword;
  final String barberIDCard;
  final String barberCertificate;
  final String barberNamelocation;
  final double barberLatitude;
  final double barberLongitude;

  BarberInfo(
      {required this.barberId,
      required this.barberFirstName,
      required this.barberLastName,
      required this.barberPhone,
      required this.barberEmail,
      required this.barberPassword,
      required this.barberIDCard,
      required this.barberCertificate,
      required this.barberNamelocation,
      required this.barberLatitude,
      required this.barberLongitude});
}

class WorkSchedule {
  final String workScheduleID;
  final DateTime workScheduleStartDate;
  final DateTime workScheduleEndDate;
  final String workScheduleNote;
  final String workScheduleBarberID;
  final int workScheduleStatus;

  WorkSchedule(
      {required this.workScheduleID,
      required this.workScheduleStartDate,
      required this.workScheduleEndDate,
      required this.workScheduleNote,
      required this.workScheduleBarberID,
      required this.workScheduleStatus});
}

class WorkingsModel {
  final String workingsId;
  final String workingsPhoto;
  final String workingsBarberID;

  WorkingsModel({
    required this.workingsId,
    required this.workingsPhoto,
    required this.workingsBarberID,
  });
}

class WorkScheduleModel {
  BarberInfo barber;
  WorkSchedule workSchedule;

  WorkScheduleModel({
    required this.barber,
    required this.workSchedule,
  });
}
