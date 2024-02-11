// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ny_shop/Models/Product.dart';

class CommonData extends ChangeNotifier {
  int step = 0;
  List<int> previousSteps = [0];
  late Product product;
  late int currentIndex = 0;
  late int? chosenSizeIndex;
  late int? chosenSize;

  changeStep(int step) {
    this.step = step;
    previousSteps.add(step);
    notifyListeners();
  }

  setProduct(Product product) {
    this.product = product;
    currentIndex = 0;
    chosenSizeIndex = null;
    chosenSize = null;
  }

  updateIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  updateChosenSize(int sizeIndex, int index) {
    chosenSizeIndex = sizeIndex;
    chosenSize = index;
    notifyListeners();
  }

  back() {
    previousSteps.removeLast();
    step = previousSteps.last;
    notifyListeners();
  }

  lastStep() {
    return previousSteps.length == 1;
  }

  void refreshPage() {
    notifyListeners();
  }
}