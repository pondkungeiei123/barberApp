// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:finalprojectbarber/model/customer_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/k_components.dart';
import '../php_data/php_data.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class LocationDetailScreen extends StatefulWidget {
  final LocationInfo model;

  const LocationDetailScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LocationDetailScreenState createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  late LocationInfo model;

  TextEditingController nameController = TextEditingController();
  final Set<Marker> _markers = {};
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void initState() {
    model = widget.model;
    super.initState();
    nameController.text = model.locationName;
    _latitude = model.locationLatitude;
    _longitude = model.locationLongitude;
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  Future<void> _addMarker(LatLng position) async {
    final Uint8List? markerIcon = await getBytesFromAsset('assets/placeholder.png', 100);
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('Address'),
          position: position,
          icon:  BitmapDescriptor.fromBytes(markerIcon!),
        ),
      );
    });
  }

  void _updateMarkerPosition(LatLng position) {
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _addMarker(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: Stack(
        children: <Widget>[
          DraggableScrollableSheet(
            maxChildSize: 1.0,
            minChildSize: 1.0,
            initialChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                height: AppTheme.fullHeight(context) * .5,
                padding: const EdgeInsets.only(
                  left: 19,
                  right: 19,
                  top: 16,
                ), //symmetric(horizontal: 19, vertical: 16),
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
                                  "แก้ไขที่อยู่",
                                  style:
                                      titleStyle.copyWith(color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Container(
                          height: 60,
                          child: TextFormField(
                            controller: nameController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'ชื่อที่อยู่',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1.0,
                          height: MediaQuery.of(context).size.height * 0.25,
                          // ignore: sort_child_properties_last
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(_latitude, _longitude),
                                zoom: 20,
                              ),
                              myLocationEnabled: true,
                              onMapCreated: (controller) {
                                _addMarker(LatLng(_latitude, _longitude));
                              },
                              markers: _markers,
                              onTap: (position) {
                                _updateMarkerPosition(position);
                              },
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  Border.all(color: const Color(0xffb8b5cb))),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: LightColor.grey.withAlpha(150),
                          ),
                          child: const Icon(
                            Icons.update,
                            color: Color.fromARGB(255, 2, 158, 255),
                          ),
                        ).ripple(
                          () async {
                            if (nameController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('ข้อผิดพลาด'),
                                    content: const Text(
                                        "กรุณากรอกข้อมูลให้ครบทุกช่อง"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('ตกลง'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              final locationModel = LocationInfo(
                                locationId: model.locationId,
                                locationLatitude: _latitude,
                                locationLongitude: _longitude,
                                locationName: nameController.text,
                                locationCusId: model.locationCusId,
                              );
                              await updateLocation(locationModel, context);
                            }
                          },
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ).vP16),
              );
            },
          ),
        ],
      ),
    );
  }
}
