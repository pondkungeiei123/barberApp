import 'dart:core';

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:flutter/cupertino.dart';

import '../model/appointment_model.dart';
import '../model/barber_model.dart';

import '../model/customer_model.dart';
import '../model/hair_model.dart';

class DataManagerProvider extends ChangeNotifier {
  bool isLoading = false;

  late List<BarberInfo> allBarbers;

  late List<WorkingsModel> allWorkings = [];
  late List<BarberBookingModel> allBarberBooking = [];
  late List<CustomerBookingModel> allCustomerBooking = [];
  late List<WorkScheduleModel> allWorkSchedule = [];
  late List<LocationInfo> allLocation = [];
  late List<HairModel> allHair = [];
  List<WorkingsModel> searchListWorkings = [];

  List<BarberInfo> searchList = [];
  List<WorkScheduleModel> searchListworkschedule = [];

  late BarberInfo barberInfo;

  late CustomerInfo customerProfile = CustomerInfo(
      customerId: "",
      customerFirstName: "",
      customerLastName: "",
      customerEmail: "",
      customerPhone: "",
      customerPassword: "");

  late BarberInfo barberProfile = BarberInfo(
      barberId: '',
      barberFirstName: '',
      barberLastName: '',
      barberPhone: '',
      barberEmail: '',
      barberPassword: '',
      barberIDCard: '',
      barberCertificate: '',
      barberNamelocation: '',
      barberLatitude: 0.0,
      barberLongitude: 0.0);

  late bool isSearching = false;

  late List<AppointmentModel> myAppointments = [];

  // late BarberModel myAppointmentWithBarber;

  List<AppointmentModel> appointmentList = [];

  bool get loading => isLoading;

  void setCustomerProfile(CustomerInfo user) {
    customerProfile = user;
    notifyListeners();
  }

  CustomerInfo get getCustomerProfile => customerProfile;

  void setBarberProfile(BarberInfo user) {
    barberProfile = user;
    notifyListeners();
  }

  BarberInfo get getBarberProfile => barberProfile;

  void setAllBarbers(List<BarberInfo> barberMapList) {
    allBarbers = barberMapList;
    notifyListeners();
  }

  void setAllWorkings(List<WorkingsModel> workingsMapList) {
    allWorkings = workingsMapList;
    notifyListeners();
  }

  void setAllBarberBookings(List<BarberBookingModel> bookingMapList) {
    allBarberBooking = bookingMapList;
    notifyListeners();
  }

  void setAllCustomerBookings(List<CustomerBookingModel> bookingMapList) {
    allCustomerBooking = bookingMapList;
    notifyListeners();
  }

  void setAllWorkSchedule(List<WorkScheduleModel> workScheduleMapList) {
    allWorkSchedule = workScheduleMapList;
    notifyListeners();
  }

  void setAllLocation(List<LocationInfo> locationMapList) {
    allLocation = locationMapList;
    notifyListeners();
  }

  void setAllHairs(List<HairModel> hairMapList) {
    allHair = hairMapList;
    notifyListeners();
  }

  List<WorkScheduleModel> get getAllWorkSchedule => allWorkSchedule;
  List<BarberBookingModel> get getAllBarberBooking => allBarberBooking;
  List<CustomerBookingModel> get getAllCustomerBooking => allCustomerBooking;
  List<LocationInfo> get getAllLocation => allLocation;
  List<WorkingsModel> get getAllWorkings => allWorkings;

  List<HairModel> get getAllHairs => allHair;

  List<BarberInfo> get getAllBarbers => allBarbers;

  List<WorkScheduleModel> get getSearchList => searchListworkschedule;

  void getSearch(String searchKey) {
    allWorkSchedule.forEach((element) {
      if (element.barber.barberFirstName
              .toLowerCase()
              .startsWith(searchKey.toLowerCase()) ||
          element.barber.barberFirstName.startsWith(searchKey.toLowerCase())) {
        searchResult(element);
      }
    });
  }

  void searchResult(WorkScheduleModel Model) {
    searchListworkschedule.add(Model);
    notifyListeners();
  }

  List<WorkScheduleModel> get getSearchListworkschedule =>
      searchListworkschedule;

  void setIsSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  bool get searchingStart => isSearching;

  void getSearchBarber(String searchKey) {
    allWorkings.forEach((element) {
      if (element.workingsPhoto
              .toLowerCase()
              .startsWith(searchKey.toLowerCase()) ||
          element.workingsPhoto.startsWith(searchKey.toLowerCase())) {
        searchResultBarber(element);
      }
    });
  }

  void searchResultBarber(WorkingsModel workings) {
    searchListWorkings.add(workings);
    notifyListeners();
  }
  // void setBarberBasicInformation(
  //     String id, String name, String email, String contact) {
  //   barberInfo = BarberInfo(
  //       barberId: id,
  //       barberFullName: name,
  //       barberEmail: email,
  //       barberContact: contact,
  //       roll: 'Barber',
  //       barberPassword: '');
  //   notifyListeners();
  // }

  // void setBarberShopInfo(
  //     String shopName,
  //     String seats,
  //     String description,
  //     String address,
  //     double latitude,
  //     double longitude,
  //     String startTime,
  //     String endTime) {
  //   Location location =
  //       Location(address: address, latitude: latitude, longitude: longitude);
  //   ShopStatus status =
  //       ShopStatus(status: 'Open', startTime: startTime, endTime: endTime);
  //   final _random = Random();
  //   String index = urls[_random.nextInt(urls.length)];
  //   barberCompleteData = BarberModel(
  //       shopName: shopName,
  //       barber: barberInfo,
  //       seats: seats,
  //       description: description,
  //       rating: 0.0,
  //       goodReviews: 0,
  //       totalScore: 0,
  //       satisfaction: 0,
  //       image: index,
  //       location: location,
  //       shopStatus: status,
  //      );
  //   notifyListeners();
  // }

  // BarberModel get getBarberDetails => barberCompleteData;

/////////////////appointment
  void setAppointmentList(List<AppointmentModel> model) {
    appointmentList = model;
    notifyListeners();
  }

  void setMyAppointments(List<AppointmentModel> model) {
    myAppointments = model;
    notifyListeners();
  }

  // void setMyAppointmentWithBarber(BarberModel barberModel) {
  //   myAppointmentWithBarber = barberModel;
  //   notifyListeners();
  // }
}
