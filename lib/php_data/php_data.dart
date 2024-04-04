// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:finalprojectbarber/barber_homepage.dart';
import 'package:finalprojectbarber/login.dart';
import 'package:finalprojectbarber/model/workings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../customer_homepage.dart';
import '../data_manager/data_manager.dart';
import '../model/barber_model.dart';
import '../model/customer_model.dart';
import 'dart:convert';

const server =
    "https://c6c5-2403-6200-8837-7557-5c0a-a72f-443f-dcc9.ngrok-free.app/BBapi";

Future<void> addCustomerProfileData(
    CustomerInfo user, BuildContext context) async {
  try {
    const url = '$server/add_customer.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'firstname': user.customerFirstName,
        'lastname': user.customerLastName,
        'email': user.customerEmail,
        'phone': user.customerPhone,
        'password': user.customerPassword,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
}

Future<bool> loginUser(
    String email, String password, String roll, BuildContext context) async {
  try {
    const url = "$server/login.php";
    final response = await http.post(
      Uri.parse(url),
      body: {'email': email, 'password': password, 'roll': roll},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        if (roll == 'Customer') {
          if (await getCustomerProfile(email, context)) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const CustomerHomePage()),
                (Route<dynamic> route) => false);
          }
        } else {
          if (await getBarberProfile(email, context)) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const BarberHomePage()),
                (Route<dynamic> route) => false);
          }
        }
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<bool> getCustomerProfile(email, BuildContext context) async {
  try {
    final url = Uri.parse('$server/get_customer.php?email=$email');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        final Map<String, dynamic> userData = data['data'];
        String id = userData['id'].toString();
        String name = userData['name'].toString();
        String lastname = userData['lastname'].toString();
        String email = userData['email'].toString();
        String phone = userData['phone'].toString();
        final cusData = CustomerInfo(
          customerId: id,
          customerFirstName: name,
          customerLastName: lastname,
          customerEmail: email,
          customerPhone: phone,
          customerPassword: '',
        );
        Provider.of<DataManagerProvider>(context, listen: false)
            .setCustomerProfile(cusData);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    return false;
  }
}

Future<bool> getBarberProfile(email, BuildContext context) async {
  try {
    final url = Uri.parse('$server/get_barber.php?email=$email');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        final Map<String, dynamic> userData = data['data'];
        String id = userData['id'].toString();
        String name = userData['name'].toString();
        String lastname = userData['lastname'].toString();
        String phone = userData['phone'].toString();
        String email = userData['email'].toString();
        String idcard = userData['idcard'].toString();
        String certificate = userData['certificate'].toString();
        String namelocation = userData['namelocation'].toString();
        double latitude = userData['latitude'];
        double longitude = userData['longitude'];
        BarberInfo barberData = BarberInfo(
            barberId: id,
            barberFirstName: name,
            barberLastName: lastname,
            barberPhone: phone,
            barberEmail: email,
            barberPassword: "",
            barberIDCard: idcard,
            barberCertificate: certificate,
            barberNamelocation: namelocation,
            barberLatitude: latitude,
            barberLongitude: longitude);
        Provider.of<DataManagerProvider>(context, listen: false)
            .setBarberProfile(barberData);
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<void> getAllWorkings(BuildContext context) async {
  List<WorkingsModel> workingsList = [];
  final String id = Provider.of<DataManagerProvider>(context, listen: false)
      .barberProfile
      .barberId;
  try {
    final url = Uri.parse('$server/get_all_workings.php/?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var workingsData = data['data'];
        if (workingsData is List) {
          for (var workings in workingsData) {
            workingsList.add(WorkingsModel(
              workingsId: workings['id'].toString(),
              workingsPhoto: workings['photo'].toString(),
              workingsBarberID: workings['ba_id'].toString(),
            ));
          }
        }

        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllWorkings(workingsList);
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

// Future<void> getAllWorkSchedule(BuildContext context) async {
//   List<WorkSchedule> workScheduleList = [];
//   final String id = Provider.of<DataManagerProvider>(context, listen: false)
//       .barberProfile
//       .barberId;
//   try {
//     final url = Uri.parse('$server/get_workSchedule.php/?id=$id');
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       if (data['result'] == 1) {
//         var workScheduleData = data['data'];
//         if (workScheduleData is List) {
//           for (var workSchedule in workScheduleData) {
//             workScheduleList.add(WorkSchedule(
//               workScheduleID: workSchedule['id'].toString(),
//               workScheduleStartDate: DateTime.parse(workSchedule['startdate']),
//               workScheduleEndDate: DateTime.parse(workSchedule['enddate']),
//               workScheduleNote: workSchedule['note'].toString(),
//               workScheduleBarberID: workSchedule['ba_id'].toString(),
//             ));
//           }
//         }
//         Provider.of<DataManagerProvider>(context, listen: false)
//             .setAllWorkSchedule(workScheduleList);
//       }
//     }
//   } catch (e) {
//     showErrorDialog('$e', context);
//   }
// }

Future<void> getAllLocation(BuildContext context) async {
  List<LocationInfo> locationList = [];
  final String id = Provider.of<DataManagerProvider>(context, listen: false)
      .customerProfile
      .customerId;
  try {
    final url = Uri.parse('$server/get_all_location.php/?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var locationData = data['data'];
        if (locationData is List) {
          for (var location in locationData) {
            locationList.add(LocationInfo(
                locationId: location['id'].toString(),
                locationName: location['name'].toString(),
                locationLatitude: location['latitude'].toDouble(),
                locationLongitude: location['longitude'].toDouble(),
                locationCusId: location['cus_id'].toString()));
          }
        }
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllLocation(locationList);
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<bool> addWorkings(
    WorkingsModel workings, File? imageFile, BuildContext context) async {
  try {
    const url = '$server/add_workings.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['photo'] = workings.workingsPhoto;
    request.fields['ba_id'] = workings.workingsBarberID;

    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();

      // Create multipart file from the image file
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'workings.jpg',
      );

      request.files.add(multipartFile);
    }
    var response = await request.send();

    var responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseString);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getAllWorkings(context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
  return false;
}

Future<bool> addLocation(
    LocationInfo locationModel, BuildContext context) async {
  try {
    const url = '$server/add_location.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': locationModel.locationName,
        'latitude': locationModel.locationLatitude.toString(),
        'longitude': locationModel.locationLongitude.toString(),
        'cus_id': locationModel.locationCusId,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getAllLocation(context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<bool> addWorkSchedule(WorkSchedule model, BuildContext context) async {
  final String id = Provider.of<DataManagerProvider>(context, listen: false)
      .barberProfile
      .barberId;
  try {
    const url = '$server/add_workSchedule.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'note': model.workScheduleNote,
        'startdate': model.workScheduleStartDate.toString(),
        'enddate': model.workScheduleEndDate.toString(),
        'ba_id': id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: const Text('สำเร็จ'),
        //       content: Text(data['message']),
        //       actions: [
        //         TextButton(
        //           onPressed: () async {
        //             // await getAllWorkSchedule(context);
        //             // Navigator.popUntil(context, (route) => route.isFirst);
        //              Navigator.pop(context);
        //           },
        //           child: const Text('ตกลง'),
        //         ),
        //       ],
        //     );
        //   },
        // );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<void> updateLocation(
    LocationInfo locationModel, BuildContext context) async {
  try {
    const url = '$server/update_location.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': locationModel.locationId,
        'name': locationModel.locationName,
        'latitude': locationModel.locationLatitude.toString(),
        'longitude': locationModel.locationLongitude.toString(),
        'cus_id': locationModel.locationCusId,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getAllLocation(context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> editProfileBarber(
    BarberInfo barberModel, BuildContext context, File? imageFile) async {
  try {
    const url = '$server/edit_barber_profile.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['id'] = barberModel.barberId;
    request.fields['name'] = barberModel.barberFirstName;
    request.fields['lastname'] = barberModel.barberLastName;
    request.fields['email'] = barberModel.barberEmail;
    request.fields['phone'] = barberModel.barberPhone;
    request.fields['password'] = barberModel.barberPassword;
    request.fields['idcard'] = barberModel.barberIDCard;
    request.fields['certificate'] = barberModel.barberCertificate;
    request.fields['namelocation'] = barberModel.barberNamelocation;
    request.fields['latitude'] = barberModel.barberLatitude.toString();
    request.fields['longitude'] = barberModel.barberLongitude.toString();

    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();

      // Create multipart file from the image file
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'cer.jpg',
      );

      // Add multipart file to the request
      request.files.add(multipartFile);
    }

    // ส่งคำขอและรอการตอบกลับ
    var response = await request.send();

    // อ่านข้อมูลการตอบกลับ
    var responseString = await response.stream.bytesToString();

    // ตรวจสอบสถานะการตอบกลับ
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseString);

      if (data['result'] == 1) {
        final Map<String, dynamic> userData = data['data'];
        String id = userData['id'].toString();
        String name = userData['name'].toString();
        String lastname = userData['lastname'].toString();
        String phone = userData['phone'].toString();
        String email = userData['email'].toString();
        String idcard = userData['idcard'].toString();
        String certificate = userData['certificate'].toString();
        String namelocation = userData['namelocation'].toString();
        double latitude = userData['latitude'];
        double longitude = userData['longitude'];
        BarberInfo barberData = BarberInfo(
            barberId: id,
            barberFirstName: name,
            barberLastName: lastname,
            barberPhone: phone,
            barberEmail: email,
            barberPassword: "",
            barberIDCard: idcard,
            barberCertificate: certificate,
            barberNamelocation: namelocation,
            barberLatitude: latitude,
            barberLongitude: longitude);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    Provider.of<DataManagerProvider>(context, listen: false)
                        .setBarberProfile(barberData);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> editProfileCustomer(
    CustomerInfo customerModel, BuildContext context) async {
  try {
    const url = '$server/edit_customer_profile.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': customerModel.customerId,
        'name': customerModel.customerFirstName,
        'lastname': customerModel.customerLastName,
        'email': customerModel.customerEmail,
        'phone': customerModel.customerPhone,
        'password': customerModel.customerPassword
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        final Map<String, dynamic> userData = data['data'];
        String id = userData['id'].toString();
        String name = userData['name'].toString();
        String lastname = userData['lastname'].toString();
        String email = userData['email'].toString();
        String phone = userData['phone'].toString();
        final cusData = CustomerInfo(
          customerId: id,
          customerFirstName: name,
          customerLastName: lastname,
          customerEmail: email,
          customerPhone: phone,
          customerPassword: '',
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    Provider.of<DataManagerProvider>(context, listen: false)
                        .setCustomerProfile(cusData);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> deleteWorkings(
    String id, String photo, BuildContext context) async {
  try {
    final url = '$server/delete_workings.php?id=$id&photo=$photo';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getAllWorkings(context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> deleteLocation(String id, BuildContext context) async {
  try {
    final url = '$server/delete_location.php?id=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getAllLocation(context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<bool> deleteWorkSchedule(String id, BuildContext context) async {
  try {
    final url = '$server/delete_workSchedule.php?id=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

void showErrorDialog(String message, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('ข้อผิดพลาด'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      );
    },
  );
}
