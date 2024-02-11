// ignore_for_file: file_names, library_prefixes

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ny_shop/Helpers/Helper.dart';
import 'package:ny_shop/Models/Product.dart';
import 'package:ny_shop/Models/User.dart' as DefaultUser;

class DataMapper {
  Helper helper = Helper();

  List<Product> getProductsFromJson(List<dynamic> list, String type) {
    List<Product> returnedProducts = [];
    for (var element in list) {
      returnedProducts.add(Product(
        element.data()['id'].toString(),
        element.data()['name'].toString(),
        type,
        element.data()['short_description'].toString(),
        element.data()['description'].toString(),
        element.data()['has_discount'],
        element.data()['price'].toString(),
        element.data()['price_after_discount'] != null
            ? element.data()['price_after_discount'].toString()
            : null,
        element.data()['main_image'],
        element.data()['images'],
        element.data()['has_sizes'] ?? false,
        element.data()['sizes'],
      ));
    }
    return returnedProducts;
  }

  DefaultUser.User getUserFromJson(
      UserCredential userData, Map<String, dynamic>? data) {
    return DefaultUser.User(
      userData.user!.uid,
      userData.user!.displayName,
      userData.user!.email,
      data != null ? data['phoneNumber'] : null,
      userData.user!.photoURL,
      data != null ? data['latitude'] : null,
      data != null ? data['longitude'] : null,
      data != null ? data['address'] : null,
    );
  }
}
