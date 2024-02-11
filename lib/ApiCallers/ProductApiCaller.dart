// ignore_for_file: file_names

import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ny_shop/Helpers/DataMapper.dart';
import 'package:ny_shop/Helpers/ResponseHandler.dart';

class ProductApiCaller {
  ResponseHandler responseHandler = ResponseHandler();
  DataMapper dataMapper = DataMapper();

  getAll(String type, int pageNumber) async {
    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
      CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection(type);
      docs = (await collection.orderBy('id').startAt([(pageNumber - 1) * 10 + 1]).limit(10).get()).docs;

      AggregateQuerySnapshot query = await FirebaseFirestore.instance.collection(type).count().get();
      int numberOfDocuments = query.count != null? query.count! : 0;

      return {
        'Err_Flag': false,
        'Values': dataMapper.getProductsFromJson(docs, type),
        'total': numberOfDocuments,
        'lastPage': (numberOfDocuments / 10).ceil()
      };
    } on TimeoutException {
      return responseHandler.timeOutPrinter();
    } on SocketException {
      return responseHandler.errorPrinter('برجاء التأكد من خدمة الإنترنت لديك');
    } catch (e) {
      return responseHandler.errorPrinter('حدث خطأ ما');
    }
  }
}
