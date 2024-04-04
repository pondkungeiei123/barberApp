// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../components/k_components.dart';
import '../model/barber_model.dart';
import '../php_data/php_data.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class BarberEditProfileScreen extends StatefulWidget {
  final BarberInfo model;

  const BarberEditProfileScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BarberEditProfileScreenState createState() =>
      _BarberEditProfileScreenState();
}

class _BarberEditProfileScreenState extends State<BarberEditProfileScreen> {
  late BarberInfo model;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idcardController = TextEditingController();
  TextEditingController namelocationController = TextEditingController();
  bool showPassword = true;
  File? _imageFile;
  final Set<Marker> _markers = {};
  double _latitude = 0.0;
  double _longitude = 0.0;
  @override
  void initState() {
    model = widget.model;
    super.initState();
    nameController.text = model.barberFirstName;
    lastnameController.text = model.barberLastName;
    phoneController.text = model.barberPhone;
    emailController.text = model.barberEmail;
    idcardController.text = model.barberIDCard;
    namelocationController.text = model.barberNamelocation;
    _latitude = model.barberLatitude;
    _longitude = model.barberLongitude;
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('Barber'),
          position: position,
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

  Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
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
                                  "แก้ไขข้อมูล",
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
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: nameController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'ชื่อ',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: lastnameController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'นามสกุล',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: idcardController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'บัตรประชาชน',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: phoneController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'เบอร์โทรศัพท์',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: emailController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'อีเมล',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: passwordController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            obscureText: showPassword,
                            decoration: kTextFormFieldDecoration.copyWith(
                                labelText: 'รหัสผ่าน',
                                suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    child: Icon(showPassword
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash))),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Container(
                          height: 45,
                          alignment: Alignment.centerLeft,
                          child: const Text("รูปใบรับรอง"),
                        ),
                        InkResponse(
                          onTap: () async {
                            File? imageFile =
                                await pickImage(ImageSource.gallery);
                            if (imageFile == null) return;
                            setState(() {
                              _imageFile = imageFile;
                            });
                          },
                          child: Container(
                            height: 150,
                            width: 200,
                            decoration: ShapeDecoration(
                              color: Colors.grey[300],
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            child: _imageFile == null
                                ? Image.network(
                                    "$server/uploads/${model.barberCertificate}")
                                : Image.file(_imageFile!),
                          ),
                        ),
                        // Container(
                        //     height: 150,
                        //     width: 300,
                        //     alignment: Alignment.center,
                        //     // ignore: unnecessary_null_comparison
                        //     child: _imageFile != null
                        //         ? Container(
                        //             height: 150,
                        //             width: 200,
                        //             color: Colors.grey[300],
                        //             child: Image.file(
                        //               _imageFile!,
                        //               height: 150,
                        //             ),
                        //           )
                        //         : model.barberCertificate != ""
                        //             ? Container(
                        //                 height: 150,
                        //                 width: 200,
                        //                 color: Colors.grey[300],
                        //                 child: Image.network(
                        //                   "$server/user/uploads/${model.barberCertificate}",
                        //                   height: 150,
                        //                 ),
                        //               )
                        //             : Container(
                        //                 height: 150,
                        //                 width: 200,
                        //                 color: Colors.grey[200],
                        //                 child:
                        //                     const Icon(Icons.image, size: 50),
                        //               )),
                        const SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: namelocationController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'ชื่อสถานที่',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
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
                                zoom: 16,
                              ),
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
                            if (nameController.text.isEmpty ||
                                lastnameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                phoneController.text.isEmpty ||
                                idcardController.text.isEmpty ||
                                namelocationController.text.isEmpty) {
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
                              final barberModel = BarberInfo(
                                barberId: model.barberId,
                                barberFirstName: nameController.text,
                                barberLastName: lastnameController.text,
                                barberPhone: phoneController.text,
                                barberEmail: emailController.text,
                                barberPassword: passwordController.text,
                                barberIDCard: idcardController.text,
                                barberCertificate: model.barberCertificate,
                                barberNamelocation: namelocationController.text,
                                barberLatitude: _latitude,
                                barberLongitude: _longitude,
                              );
                              await editProfileBarber(
                                  barberModel, context, _imageFile);
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
