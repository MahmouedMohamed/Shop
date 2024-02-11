// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomSpacing extends StatelessWidget {
  final double value;
  const CustomSpacing({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height/value);
  }
}