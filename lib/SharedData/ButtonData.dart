// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class ButtonData extends ChangeNotifier{
  Map<String, bool> isLoading = {'order': false, 'update': false, 'location': false};

  changeLoadingState(String button) {
      isLoading[button] = !isLoading[button]!;
      notifyListeners();
  }
}