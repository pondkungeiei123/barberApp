import 'package:finalprojectbarber/barber_homepage.dart';
import 'package:finalprojectbarber/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../customer_homepage.dart';
import '../data_manager/data_manager.dart';
import '../model/barber_model.dart';
import '../model/user_model.dart';
import 'dart:convert';

import '../screen/barber/barber_dashboard.dart';

Future<void> addCustomerProfileData(
    CustomerInfo user, BuildContext context) async {
  try {
    const url = 'http://127.0.0.1/user/add_customer.php';

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
              title: Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                  child: Text('ตกลง'),
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

Future<void> loginUser(
    String email, String password, String roll, BuildContext context) async {
  try {
    final url = 'http://127.0.0.1/user/login.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'email': email,
        'password': password,
        'roll': roll,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        if (roll == 'Customer') {
          await getCustomerProfile(email, context).whenComplete(() {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const customerHomePage()),
                (Route<dynamic> route) => false);
          });
        } else {
          await getBarberProfile(email, context).whenComplete(() {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const barberHomePage()),
                (Route<dynamic> route) => false);
          });
        }
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
}

Future<void> getCustomerProfile(email, BuildContext context) async {
  try {
    final url =
        Uri.parse('http://127.0.0.1/user/get_customer.php?email=$email');
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
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
}

Future<void> getBarberProfile(email, BuildContext context) async {
  try {
    final url =
        Uri.parse('http://127.0.0.1/user/get_barber.php?email=$email');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        late BarberModel barbP;
        BarberInfo barber = BarberInfo(
            barberId: data['barberId'],
            barberFullName: data['fullName'],
            barberEmail: data['email'],
            barberContact: data['contact'],
            roll: 'Barbers',
            barberPassword: '');

        Location location = Location(
            address: data['address'],
            latitude: data['latitude'],
            longitude: data['longitude']);

        ShopStatus status = ShopStatus(
            status: data['shopStatus'],
            startTime: data['startTime'],
            endTime: data['endTime']);

        barbP = BarberModel(
            shopName: data['shopName'],
            barber: barber,
            seats: data['seats'],
            description: data['description'],
            rating: double.parse("${data['rating']}"),
            goodReviews: data['goodReviews'],
            totalScore: data['totalScore'],
            satisfaction: data['satisfaction'],
            image: data['image'],
            location: location,
            shopStatus: status);

        Provider.of<DataManagerProvider>(context, listen: false)
            .setBarberProfile(barbP);
      } else {
        showErrorDialog(data['message'], context);
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
}

void showErrorDialog(String message, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ข้อผิดพลาด'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ตกลง'),
          ),
        ],
      );
    },
  );
}
