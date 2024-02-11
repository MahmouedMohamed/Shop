// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CartData extends ChangeNotifier {
  List<Map<String, dynamic>> cartData = [];
  double totalPrice = 0.0;

  addItem(Map<String, dynamic> item) {
    Iterable<Map<String, dynamic>> exists =
        cartData.where((element) => element['id'] == item['id'] && element['product_type'] == item['product_type']);
    if (exists.isNotEmpty) {
      removeItem(item['id'], item['product_type']);
      return;
    }
    cartData.add(item);
    totalPrice += double.parse(item['price'].toString());
    notifyListeners();
  }

  hasItem(String id, String type) {
    Iterable<Map<String, dynamic>> exists =
        cartData.where((element) => element['id'] == id && element['product_type'] == type);
    if (exists.isEmpty) {
      return false;
    }
    return true;
  }

  removeItem(String id, String type) {
    Iterable<Map<String, dynamic>> exists =
        cartData.where((element) => element['id'] == id && element['product_type'] == type);
    if (exists.isEmpty) {
      return;
    }
    totalPrice -= double.parse(exists.first['price'].toString());
    cartData.removeWhere((element) => element['id'] == id && element['product_type'] == type);
    notifyListeners();
  }

  empty() {
    cartData = [];
    totalPrice = 0.0;
    notifyListeners();
  }
}
