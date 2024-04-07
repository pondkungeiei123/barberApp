// ignore_for_file: use_build_context_synchronously

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import '../php_data/route.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class BarBerBookingDetailScreen extends StatefulWidget {
  final BookingModel model;

  const BarBerBookingDetailScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BarBerBookingDetailScreenState createState() =>
      _BarBerBookingDetailScreenState();
}

class _BarBerBookingDetailScreenState extends State<BarBerBookingDetailScreen> {
  late BookingModel model;
  Set<Marker> _markers = {};
  late double _barberLatitude = 0.0;
  late double _barberLongitude = 0.0;
  late double _customerLatitude = 0.0;
  late double _customerLongitude = 0.0;
  late Set<Polyline> _polylines = {};

  Future<void> _getUserLocationAndAddMarker(LatLng Customerposition) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ข้อผิดพลาด'),
            content: const Text('คุณไม่อนุญาตให้เข้าถึงตำแหน่งปัจจุบัน'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ตกลง'),
              ),
            ],
          );
        },
      );
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _barberLatitude = position.latitude;
      _barberLongitude = position.longitude;
    });
    await _addMarker(
        LatLng(_barberLatitude, _barberLongitude), Customerposition);
  }

  void _addPolyline(LatLng start, LatLng end) async {
    RouteM? route = await getRoute(start, end);
    if (route != null) {
      List<LatLng> polylineCoordinates = decodePolyline(route.encodedRoute);
      Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.blue,
        width: 3,
        points: polylineCoordinates,
      );
      setState(() {
        _polylines.clear();
        _polylines.add(polyline);
      });
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  Future<void> _addMarker(
      LatLng barberPosition, LatLng customerPosition) async {
    // Add barber marker
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('barberMarker'),
        position: barberPosition,
        infoWindow: const InfoWindow(title: 'ช่างตัดผม'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
      _markers.add(Marker(
        markerId: const MarkerId('customerMarker'),
        position: customerPosition,
        infoWindow: const InfoWindow(title: 'ลูกค้า'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });
    _addPolyline(barberPosition, customerPosition);
  }

  @override
  void initState() {
    model = widget.model;
    super.initState();
    _customerLatitude = widget.model.location.locationLatitude;
    _customerLongitude = widget.model.location.locationLongitude;
    _getUserLocationAndAddMarker(LatLng(_customerLatitude, _customerLongitude));
  }

  @override
  Widget build(BuildContext context) {
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
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "${model.customer.customerFirstName} ${model.customer.customerLastName}",
                                  style: TextStyles.bodySm.subTitleColor.bold,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  model.booking.bookingStatus == 0
                                      ? "รอยืนยัน"
                                      : "ไม่ว่าง",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: model.booking.bookingStatus == 0
                                        ? Colors.blue[400]
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
                          Text("ข้อมูล", style: titleStyle).vP16,
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
                                  " วันที่ ${DateFormat.MMMMd('th-TH').format(model.workScheduleStartDate)}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3.0,
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
                                  " เวลา ${DateFormat('HH:mm').format(model.workScheduleStartDate)} น. - ${DateFormat('HH:mm').format(model.workScheduleEndDate)} น.",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.face,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  " ${model.hair.hairName}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.attach_money_outlined,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  " รวม ${model.booking.bookingPrice} บาท",
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
                                  model.location.locationName,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(color: const Color(0xffb8b5cb))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      _customerLatitude, _customerLongitude),
                                  zoom: 13.0,
                                ),
                                markers: _markers,
                                polylines: _polylines,
                                onTap: (position) {},
                                onMapCreated: (controller) {
                                  _addMarker(
                                    LatLng(_barberLatitude, _barberLongitude),
                                    LatLng(
                                        _customerLatitude, _customerLongitude),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.greenAccent,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ).ripple(
                                () {
                                  // _launchCaller(model.barber.barberContact);
                                },
                                borderRadius: BorderRadius.circular(10),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.redAccent,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ).ripple(
                                () {
                                  // _smsLauncher(model.barber.barberContact);
                                },
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
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

// double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//   const double earthRadius = 6371.0710; // รัศมีของโลกในหน่วยกิโลเมตร

//   // แปลงพิกัดเป็นเรเดียน (radians)
//   double lat1Rad = radians(lat1);
//   double lon1Rad = radians(lon1);
//   double lat2Rad = radians(lat2);
//   double lon2Rad = radians(lon2);

//   // คำนวณค่าต่างๆ
//   double dLat = lat2Rad - lat1Rad;
//   double dLon = lon2Rad - lon1Rad;

//   // ใช้สูตร Haversine Formula เพื่อคำนวณระยะห่าง
//   double a = sin(dLat / 2) * sin(dLat / 2) +
//       cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
//   double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//   // คำนวณระยะห่างโดยคูณกับรัศมีของโลก
//   double distance = earthRadius * c;
//   return distance;
// }

// double getZoomLevel(double distance) {
//   const double mapWidth = 256.0; // ความกว้างของแผนที่ Google Maps ในหน่วยพิกเซล
//   const double zoomMax = 21.0; // Zoom Level สูงสุดที่ Google Maps รองรับ

//   // เริ่มต้นคำนวณ Zoom Level
//   double equatorLength = 40075004; // ความยาวของอีกวายร์ในหน่วยเมตร
//   double metersPerPixel = equatorLength / mapWidth; // จำนวนเมตรต่อพิกเซล

//   // คำนวณ Zoom Level ตามระยะทางที่กำหนด
//   double zoom = (math.log(distance / metersPerPixel) / math.log(2)).abs();
//   return zoom <= zoomMax
//       ? zoom
//       : zoomMax; // กำหนด Zoom Level สูงสุดเท่ากับ zoomMax
// }

// double radians(double degrees) {
//   return degrees * pi / 180;
// }
