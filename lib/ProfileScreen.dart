// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ny_shop/ApiCallers/UserApiCaller.dart';
import 'package:ny_shop/CustomWidgets/CustomButtonLoading.dart';
import 'package:ny_shop/CustomWidgets/CustomSpacing.dart';
import 'package:ny_shop/Models/GeoLocator.dart';
import 'package:ny_shop/Session/SessionManager.dart';
import 'package:ny_shop/SharedData/AppLanguage.dart';
import 'package:ny_shop/SharedData/AppTheme.dart';
import 'package:ny_shop/SharedData/CommonData.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SessionManager sessionManager = SessionManager();
  static final TextEditingController phoneNumberController =
      TextEditingController();
  static final TextEditingController latitudeController =
      TextEditingController();
  static final TextEditingController longitudeController =
      TextEditingController();
  static final TextEditingController addressController =
      TextEditingController();
  static late double w, h;
  static late AppLanguage appLanguage;
  static late AppTheme appTheme;
  final GeoLocator geoLocator = GeoLocator();
  String error = '';
  Map<String, bool> isLoading = {'update': false, 'location': false};
  String loginMethod = 'Email&Password';
  String get phoneNumber => phoneNumberController.text;
  String get latitude => latitudeController.text;
  String get longitude => longitudeController.text;
  String get address => addressController.text;

  @override
  initState() {
    super.initState();
    phoneNumberController.text = sessionManager.user!.phoneNumber != null
        ? sessionManager.user!.phoneNumber!
        : '';
    latitudeController.text = sessionManager.user!.latitude != null
        ? sessionManager.user!.latitude!
        : '';
    longitudeController.text = sessionManager.user!.longitude != null
        ? sessionManager.user!.longitude!
        : '';
    addressController.text = sessionManager.user!.address != null
        ? sessionManager.user!.address!
        : '';
  }

  Future<dynamic> onSubmit(context) async {
    try {
      changeLoadingState('update');
      Future.delayed(const Duration(seconds: 5));
      UserApiCaller userApiCaller = UserApiCaller();
      Map<String, dynamic> status = await userApiCaller.changeProfileInfo(
          phoneNumber, latitude, longitude, address);
      if (status['Err_Flag']) {
        changeLoadingState('update');
        setState(() {
          error = status['Err_Desc'];
        });
        return;
      }
      sessionManager.changeUserInfo(phoneNumber, latitude, longitude, address);
      changeLoadingState('update');
    } catch (ex) {
      changeLoadingState('update');
    }
  }

  changeLoadingState(String button) {
    setState(() {
      isLoading[button] = !isLoading[button]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    appTheme = Provider.of<AppTheme>(context);
    appLanguage = Provider.of<AppLanguage>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(39, 49, 56, 1.0),
          image: DecorationImage(
              image: AssetImage('assets/images/tasker-oversigt.jpg'),
              fit: BoxFit.cover,
              // colorFilter: ColorFilter.mode(
              //     Colors.black.withOpacity(0.3), BlendMode.darken),
              alignment: Alignment.center),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: h / 15, right: w / 20, left: w / 20),
              padding: EdgeInsets.only(
                  top: h / 50, bottom: h / 50, left: w / 40, right: w / 40),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        spreadRadius: 5,
                        blurRadius: 10)
                  ]),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Update Profile',
                        style: appTheme.nonStaticGetTextStyle(
                            1.5,
                            Colors.brown.shade800,
                            appTheme.mediumTextSize(context) * 1.3,
                            FontWeight.w700,
                            1.0,
                            TextDecoration.none),
                        textAlign: TextAlign.center,
                      )),
                  const CustomSpacing(value: 50),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: w / 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w / 50),
                            child: Text(
                              'Phone Number',
                              style: appTheme.nonStaticGetTextStyle(
                                  1.5,
                                  Colors.brown.shade800,
                                  appTheme.mediumTextSize(context),
                                  FontWeight.w600,
                                  1.0,
                                  TextDecoration.none),
                            ),
                          ),
                          const CustomSpacing(value: 100),
                          TextField(
                            controller: phoneNumberController,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true),
                            cursorColor: const Color.fromRGBO(127, 148, 174, 1),
                            style: appTheme.nonStaticGetTextStyle(
                                1.5,
                                Colors.brown,
                                appTheme.mediumTextSize(context),
                                FontWeight.w500,
                                1.0,
                                TextDecoration.none),
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: h / 100, horizontal: w / 25),
                              hintStyle: appTheme.nonStaticGetTextStyle(
                                  1.5,
                                  Colors.brown.withOpacity(0.5),
                                  appTheme.smallTextSize(context),
                                  FontWeight.w500,
                                  1.0,
                                  TextDecoration.none),
                              hintFadeDuration: const Duration(milliseconds: 500),
                              fillColor: Colors.white,
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              filled: true,
                              prefixIconConstraints: BoxConstraints(
                                  minWidth: w / 20, minHeight: h / 20),
                            ),
                          ),
                        ],
                      )),
                  const CustomSpacing(value: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: w / 4,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: latitudeController,
                          enabled: false,
                          keyboardType:
                              const TextInputType.numberWithOptions(signed: true),
                          cursorColor: const Color.fromRGBO(127, 148, 174, 1),
                          style: appTheme.nonStaticGetTextStyle(
                              1.5,
                              Colors.brown,
                              appTheme.mediumTextSize(context),
                              FontWeight.w500,
                              1.0,
                              TextDecoration.none),
                          decoration: InputDecoration(
                            hintText: 'Latitude',
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: h / 100, horizontal: w / 25),
                            hintStyle: appTheme.nonStaticGetTextStyle(
                                1.5,
                                Colors.brown.withOpacity(0.5),
                                appTheme.smallTextSize(context),
                                FontWeight.w500,
                                1.0,
                                TextDecoration.none),
                            hintFadeDuration: const Duration(milliseconds: 500),
                            fillColor: Colors.white,
                            hoverColor: Colors.white,
                            focusColor: Colors.white,
                            filled: true,
                            prefixIconConstraints: BoxConstraints(
                                minWidth: w / 20, minHeight: h / 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: w / 25,
                      ),
                      SizedBox(
                        width: w / 4,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: longitudeController,
                          keyboardType:
                              const TextInputType.numberWithOptions(signed: true),
                          cursorColor: const Color.fromRGBO(127, 148, 174, 1),
                          style: appTheme.nonStaticGetTextStyle(
                              1.5,
                              Colors.brown,
                              appTheme.mediumTextSize(context),
                              FontWeight.w500,
                              1.0,
                              TextDecoration.none),
                          decoration: InputDecoration(
                            hintText: 'Longitude',
                            isDense: true,
                            enabled: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: h / 100, horizontal: w / 25),
                            hintStyle: appTheme.nonStaticGetTextStyle(
                                1.5,
                                Colors.brown.withOpacity(0.5),
                                appTheme.smallTextSize(context),
                                FontWeight.w500,
                                1.0,
                                TextDecoration.none),
                            hintFadeDuration: const Duration(milliseconds: 500),
                            fillColor: Colors.white,
                            hoverColor: Colors.white,
                            focusColor: Colors.white,
                            filled: true,
                            prefixIconConstraints: BoxConstraints(
                                minWidth: w / 20, minHeight: h / 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: w / 25,
                      ),
                      isLoading['location']!
                          ? const CustomButtonLoading()
                          : IconButton(
                              onPressed: () async {
                                changeLoadingState('location');
                                try {
                                  Position location =
                                      (await geoLocator.determinePosition());
                                  setState(() {
                                    latitudeController.text =
                                        location.latitude.toString();
                                    longitudeController.text =
                                        location.longitude.toString();
                                  });
                                  changeLoadingState('location');
                                } catch (exception) {
                                  changeLoadingState('location');
                                }
                              },
                              icon: const Icon(
                                Icons.location_on_outlined,
                                color: Colors.brown,
                              ))
                    ],
                  ),
                  const CustomSpacing(
                    value: 80,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: w / 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w / 50),
                            child: Text(
                              'Address',
                              style: appTheme.nonStaticGetTextStyle(
                                  1.5,
                                  Colors.brown.shade800,
                                  appTheme.mediumTextSize(context),
                                  FontWeight.w600,
                                  1.0,
                                  TextDecoration.none),
                            ),
                          ),
                          const CustomSpacing(value: 100),
                          TextField(
                            controller: addressController,
                            cursorColor: const Color.fromRGBO(127, 148, 174, 1),
                            style: appTheme.nonStaticGetTextStyle(
                                1.5,
                                Colors.brown,
                                appTheme.mediumTextSize(context),
                                FontWeight.w500,
                                1.0,
                                TextDecoration.none),
                            decoration: InputDecoration(
                              hintText: 'Enter your address',
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: h / 100, horizontal: w / 25),
                              hintStyle: appTheme.nonStaticGetTextStyle(
                                  1.5,
                                  Colors.brown.withOpacity(0.5),
                                  appTheme.smallTextSize(context),
                                  FontWeight.w500,
                                  1.0,
                                  TextDecoration.none),
                              hintFadeDuration:
                                  const Duration(milliseconds: 500),
                              fillColor: Colors.white,
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              filled: true,
                              prefixIconConstraints: BoxConstraints(
                                  minWidth: w / 20, minHeight: h / 20),
                            ),
                          ),
                        ],
                      )),
                  const CustomSpacing(
                    value: 80,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: w / 10),
                      child: Text(
                        error,
                        style: appTheme.nonStaticGetTextStyle(
                            1.5,
                            Colors.red[500],
                            appTheme.mediumTextSize(context),
                            FontWeight.w500,
                            1.0,
                            TextDecoration.none),
                        textAlign: TextAlign.center,
                      )),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    isLoading['update']!
                        ? const CustomButtonLoading()
                        : ElevatedButton(
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(w / 4, h / 20)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.brown.shade700),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                            onPressed: () {
                              onSubmit(context);
                            },
                            child: Text(
                              'Change Profile Info',
                              style: appTheme.nonStaticGetTextStyle(
                                  1.5,
                                  Colors.white,
                                  appTheme.mediumTextSize(context),
                                  FontWeight.w500,
                                  1.0,
                                  TextDecoration.none),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ]),
                  const CustomSpacing(value: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
