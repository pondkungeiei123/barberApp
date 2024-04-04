import 'dart:core';

import 'package:finalprojectbarber/model/workings_model.dart';
import 'package:flutter/cupertino.dart';

import '../model/appointment_model.dart';
import '../model/barber_model.dart';

import '../model/customer_model.dart';


class DataManagerProvider extends ChangeNotifier {
  bool isLoading = false;

  late List<BarberInfo> allBarbers;

  late List<WorkingsModel> allWorkings = [];
  late List<WorkSchedule> allWorkSchedule = [];
  late List<LocationInfo> allLocation = [];
  List<WorkingsModel> searchListWorkings = [];

  List<BarberInfo> searchList = [];

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

  void setLoadingStatus(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

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

  void setAllWorkSchedule(List<WorkSchedule> workScheduleMapList) {
    allWorkSchedule = workScheduleMapList;
    notifyListeners();
  }


  void setAllLocation(List<LocationInfo> locationMapList) {
    allLocation = locationMapList;
    notifyListeners();
  }

  List<WorkSchedule> get getAllWorkSchedule => allWorkSchedule;
  List<LocationInfo> get getAllLocation => allLocation;
  List<WorkingsModel> get getAllWorkings => allWorkings;

  List<BarberInfo> get getAllBarbers => allBarbers;

  void getSearch(String searchKey) {
    allBarbers.forEach((element) {
      if (element.barberFirstName
              .toLowerCase()
              .startsWith(searchKey.toLowerCase()) ||
          element.barberFirstName.startsWith(searchKey.toLowerCase())) {
        searchResult(element);
      }
    });
  }

  void searchResult(BarberInfo barberModel) {
    searchList.add(barberModel);
    notifyListeners();
  }

  List<BarberInfo> get getSearchList => searchList;

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
