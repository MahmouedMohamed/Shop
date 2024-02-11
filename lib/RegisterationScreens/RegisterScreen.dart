// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:ny_shop/ApiCallers/UserApiCaller.dart';
import 'package:ny_shop/CustomWidgets/CustomButtonLoading.dart';
import 'package:ny_shop/CustomWidgets/CustomSpacing.dart';
import 'package:ny_shop/Session/SessionManager.dart';
import 'package:ny_shop/SharedData/AppTheme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final SessionManager sessionManager = SessionManager();
  static final TextEditingController emailController = TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();
  static late double w, h;
  static late AppTheme appTheme;
  // static late AppLanguage appLanguage;
  String error = '';
  bool isLoading = false;
  String get email => emailController.text;
  String get password => passwordController.text;

  Future<dynamic> onSubmit(context) async {
    try {
      changeLoadingState();
      UserApiCaller userApiCaller = UserApiCaller();
      Map<String, dynamic> status =
          await userApiCaller.register(email, password);
      if (status['Err_Flag']) {
        changeLoadingState();
        setState(() {
          error = status['Err_Desc'];
        });
        return;
      }
      sessionManager.createSession(status['Values']);
      passwordController.text = '';
      emailController.text = '';
      Navigator.popUntil(context, (route) => false);
      Navigator.pushNamed(context, 'MainScreen');
    } catch (ex) {
      changeLoadingState();
    }
  }

  changeLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    appTheme = AppTheme(context);
    // appLanguage = AppLanguage(sessionManager.loadPreferredLanguage() ?? 'en');
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Material(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(39, 49, 56, 1.0),
              image: DecorationImage(
                  image: AssetImage('assets/images/pexels-lumn-167686.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center),
            ),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: h / 10, bottom: h / 50),
                    child: Container(
                      height: h / 6,
                      width: h / 6,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/NY.png')),
                      ),
                    )),
                Container(
                  margin:
                      EdgeInsets.only(top: h / 15, right: w / 20, left: w / 20),
                  padding: EdgeInsets.only(
                      top: h / 50, bottom: h / 50, left: w / 40, right: w / 40),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
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
                      Padding(
                        padding: EdgeInsets.only(left: w / 25),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Register a new account',
                              style: appTheme.nonStaticGetTextStyle(
                                  2.0,
                                  Colors.white,
                                  appTheme.mediumTextSize(context),
                                  FontWeight.w500,
                                  1.0,
                                  TextDecoration.none),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      const CustomSpacing(value: 50),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: w / 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: w / 50),
                                child: Text(
                                  'Email*',
                                  style: appTheme.nonStaticGetTextStyle(
                                      1.5,
                                      Colors.white.withOpacity(0.8),
                                      appTheme.mediumTextSize(context),
                                      FontWeight.w500,
                                      1.0,
                                      TextDecoration.none),
                                ),
                              ),
                              const CustomSpacing(value: 100),
                              TextField(
                                controller: emailController,
                                cursorColor:
                                    const Color.fromRGBO(127, 148, 174, 1),
                                style: appTheme.nonStaticGetTextStyle(
                                    1.5,
                                    Colors.grey.shade100,
                                    appTheme.mediumTextSize(context),
                                    FontWeight.w400,
                                    1.0,
                                    TextDecoration.none),
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: h / 100, horizontal: w / 25),
                                  hintStyle: appTheme.nonStaticGetTextStyle(
                                      1.5,
                                      Colors.white.withOpacity(0.8),
                                      appTheme.mediumTextSize(context),
                                      FontWeight.w100,
                                      1.0,
                                      TextDecoration.none),
                                  hintFadeDuration:
                                      const Duration(milliseconds: 500),
                                  fillColor: Colors.brown.shade200,
                                  hoverColor:
                                      const Color.fromRGBO(241, 244, 249, 1),
                                  focusColor:
                                      const Color.fromRGBO(241, 244, 249, 1),
                                  filled: true,
                                  prefixIconConstraints: BoxConstraints(
                                      minWidth: w / 20, minHeight: h / 20),
                                ),
                              ),
                              const CustomSpacing(value: 70),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: w / 50),
                                child: Text(
                                  'Password*',
                                  style: appTheme.nonStaticGetTextStyle(
                                      1.5,
                                      Colors.white.withOpacity(0.8),
                                      appTheme.mediumTextSize(context),
                                      FontWeight.w500,
                                      1.0,
                                      TextDecoration.none),
                                ),
                              ),
                              const CustomSpacing(value: 100),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                cursorColor:
                                    const Color.fromRGBO(127, 148, 174, 1),
                                style: appTheme.nonStaticGetTextStyle(
                                    1.5,
                                    Colors.grey.shade100,
                                    appTheme.mediumTextSize(context),
                                    FontWeight.w400,
                                    1.0,
                                    TextDecoration.none),
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: h / 100, horizontal: w / 25),
                                  hintStyle: appTheme.nonStaticGetTextStyle(
                                      1.5,
                                      Colors.white.withOpacity(0.8),
                                      appTheme.mediumTextSize(context),
                                      FontWeight.w100,
                                      1.0,
                                      TextDecoration.none),
                                  hintFadeDuration:
                                      const Duration(milliseconds: 500),
                                  fillColor: Colors.brown.shade200,
                                  hoverColor:
                                      const Color.fromRGBO(241, 244, 249, 1),
                                  focusColor:
                                      const Color.fromRGBO(241, 244, 249, 1),
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
                                Colors.red[200],
                                appTheme.mediumTextSize(context),
                                FontWeight.w500,
                                1.0,
                                TextDecoration.none),
                            textAlign: TextAlign.center,
                          )),
                      const CustomSpacing(
                        value: 80,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLoading
                                ? const CustomButtonLoading()
                                : ElevatedButton(
                                    style: ButtonStyle(
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(w / 4, h / 20)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.brown.shade400),
                                        shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10)))),
                                    onPressed: () {
                                      onSubmit(context);
                                    },
                                    child: Text(
                                      'Register',
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
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'Already have Account? ',
                                style: appTheme.nonStaticGetTextStyle(
                                    1.5,
                                    Colors.white,
                                    appTheme.smallTextSize(context),
                                    FontWeight.w500,
                                    1.0,
                                    TextDecoration.none),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'LoginScreen');
                                },
                                child: Text(
                                  'Login Now!',
                                  style: appTheme.nonStaticGetTextStyle(
                                      1.5,
                                      Colors.green[300],
                                      appTheme.mediumTextSize(context),
                                      FontWeight.w900,
                                      1.0,
                                      TextDecoration.none),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
