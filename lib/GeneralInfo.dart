// ignore_for_file: constant_identifier_names

import 'package:ny_shop/DetailedProductScreen.dart';
import 'package:ny_shop/CheckoutScreen.dart';
import 'package:ny_shop/ProfileScreen.dart';
import 'package:ny_shop/main.dart';

enum Pages {
  // MyDonationScreen,
  HomeScreen,
  // SettingsScreen,
  // NeedyCreationScreen,
  // OnlineTransactionCreationScreen,
  // OfflineTransactionCreationScreen,
  // OfflineTransactionUpdateScreen,
  ProfileScreen,
  DetailedProductScreen,
  CheckoutScreen,
  // StayInTouchScreen,
  // LoginScreen
}


final pageOptions = [
  const MyHomePage(),
  // SettingsScreen(),
  // NeedyCreationScreen(),
  // OnlineTransactionCreationScreen(),
  // OfflineTransactionCreationScreen(),
  // OfflineTransactionUpdateScreen(),
  const ProfileScreen(),
  const DetailedProductScreen(),
  const CheckoutScreen(),
  // StayInTouchScreen(),
  // LoginScreen()
];