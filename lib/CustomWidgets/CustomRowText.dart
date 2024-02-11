// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ny_shop/SharedData/AppTheme.dart';
import 'package:provider/provider.dart';

class CustomRowText extends StatelessWidget {
  final String firstText;
  final String secondText;
  static late double h, w;
  static late AppTheme appTheme;
  const CustomRowText(
      {super.key, required this.firstText, required this.secondText});

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.width;
    w = MediaQuery.of(context).size.width;
    appTheme = Provider.of<AppTheme>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: w / 4,
          child: Text(
            firstText,
            textAlign: TextAlign.left,
            style: appTheme.nonStaticGetTextStyle(
                1.5,
                Colors.grey,
                appTheme.mediumTextSize(context) * 0.9,
                FontWeight.w600,
                1.0,
                TextDecoration.none),
          ),
        ),
        SizedBox(
          width: w / 6 * 2,
          child: Text(
            secondText,
            textAlign: TextAlign.left,
            maxLines: 1,
            style: appTheme.nonStaticGetTextStyle(
                1.5,
                Color.fromRGBO(23, 45, 84, 1),
                appTheme.mediumTextSize(context) * 1.1,
                FontWeight.w600,
                1.0,
                TextDecoration.none),
          ),
        ),
      ],
    );
  }
}
