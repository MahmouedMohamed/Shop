// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ny_shop/Helpers/DataMapper.dart';
import 'package:ny_shop/Helpers/ResponseHandler.dart';
import 'package:ny_shop/Session/SessionManager.dart';

class UserApiCaller {
  ResponseHandler responseHandler = ResponseHandler();
  SessionManager sessionManager = SessionManager();
  DataMapper dataMapper = DataMapper();
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({});
        return {
          'Err_Flag': false,
          'Values': dataMapper.getUserFromJson(userCredential, null),
        };
      }
      return responseHandler.errorPrinter('Invalid Credentials.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return responseHandler.errorPrinter('Weak Password.');
      } else if (e.code == 'email-already-in-use') {
        return responseHandler.errorPrinter('Email is already in use.');
      }
      return responseHandler.errorPrinter('Something went wrong.');
    } catch (e) {
      return responseHandler.errorPrinter('Something went wrong.');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> document =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        return {
          'Err_Flag': false,
          'Values': dataMapper.getUserFromJson(userCredential, document.data()),
        };
      }
      return responseHandler.errorPrinter('Invalid Credentials.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return responseHandler.errorPrinter('Invalid Email.');
      } else if (e.code == 'user-disabled') {
        return responseHandler.errorPrinter('User Disabled.');
      }
      return responseHandler.errorPrinter('Invalid Credentials.');
    } catch (e) {
      print(e);
      return responseHandler.errorPrinter('Something went wrong.');
    }
  }

  Future<Map<String, dynamic>> forgetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return {
        'Err_Flag': false,
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return responseHandler.errorPrinter('Invalid Email.');
      } else if (e.code == 'user-not-found') {
        return responseHandler.errorPrinter('User Not Found.');
      }
      return responseHandler.errorPrinter('Invalid Credentials.');
    } catch (e) {
      return responseHandler.errorPrinter('Something went wrong.');
    }
  }

  Future<Map<String, dynamic>> changeProfileInfo(String? phoneNumber,
      String? latitude, String? longitude, String? address) async {
    try {
      Map<String, dynamic> data = {};
      data['phoneNumber'] = phoneNumber != null && phoneNumber != ''
          ? phoneNumber
          : sessionManager.user?.phoneNumber;
      data['latitude'] = latitude != null && latitude != ''
          ? latitude
          : sessionManager.user?.latitude;
      data['longitude'] = longitude != null && longitude != ''
          ? longitude
          : sessionManager.user?.longitude;
      data['address'] = address != null && address != ''
          ? address
          : sessionManager.user?.address;

      if (data.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(sessionManager.user?.id)
            .set(data);
      }

      return {
        'Err_Flag': false,
      };
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'invalid-email') {
        return responseHandler.errorPrinter('Invalid Email.');
      } else if (e.code == 'user-not-found') {
        return responseHandler.errorPrinter('User Not Found.');
      }
      return responseHandler.errorPrinter('Invalid Credentials.');
    } catch (e) {
      return responseHandler.errorPrinter('Something went wrong.');
    }
  }

  Future<Map<String, dynamic>> order(List<Map<String,dynamic>> orderData, double totalPrice) async {
    try {
      Map<String, dynamic> data = {};

      data['user_id'] = sessionManager.user?.id;
      data['address'] = sessionManager.user?.address;
      data['phone_number'] = sessionManager.user?.phoneNumber;
      data['latitude'] = sessionManager.user?.latitude;
      data['longitude'] = sessionManager.user?.longitude;
      data['order_details'] = orderData.map((item) => {
        'product_id' : item['id'],
        'type': item['product_type'],
        'price': item['price'],
        'selected_size': item['selected_size']
      });
      data['price'] = totalPrice;

      print(data);
      if (data.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('orders')
            .doc()
            .set(data);
      }

      return {
        'Err_Flag': false,
      };
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'invalid-email') {
        return responseHandler.errorPrinter('Invalid Email.');
      } else if (e.code == 'user-not-found') {
        return responseHandler.errorPrinter('User Not Found.');
      }
      return responseHandler.errorPrinter('Invalid Credentials.');
    } catch (e) {
      print(e);
      return responseHandler.errorPrinter('Something went wrong.');
    }
  }
}
