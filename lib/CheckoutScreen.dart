import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:ny_shop/ApiCallers/UserApiCaller.dart';
import 'package:ny_shop/CustomWidgets/CustomButtonLoading.dart';
import 'package:ny_shop/CustomWidgets/CustomRowText.dart';
import 'package:ny_shop/CustomWidgets/CustomSpacing.dart';
import 'package:ny_shop/GeneralInfo.dart';
import 'package:ny_shop/Session/SessionManager.dart';
import 'package:ny_shop/SharedData/AppTheme.dart';
import 'package:ny_shop/SharedData/ButtonData.dart';
import 'package:ny_shop/SharedData/CartData.dart';
import 'package:ny_shop/SharedData/CommonData.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  static late CommonData commonData;
  static late AppTheme appTheme;
  static late CartData cartData;
  static late ButtonData buttonData;
  static final SessionManager sessionManager = SessionManager();

  static late double w, h;
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.sizeOf(context).width;
    h = MediaQuery.sizeOf(context).height;
    commonData = Provider.of<CommonData>(context);
    appTheme = Provider.of<AppTheme>(context);
    cartData = Provider.of<CartData>(context);
    buttonData = Provider.of<ButtonData>(context);
    return Container(
      padding: EdgeInsets.only(top: h / 15),
      color: const Color.fromRGBO(241, 244, 249, 1),
      // height: h,
      child: Column(
        children: [
          Text(
            'My Cart',
            style: appTheme.nonStaticGetTextStyle(
                1.5,
                const Color.fromRGBO(23, 45, 84, 1),
                appTheme.largeTextSize(context),
                FontWeight.w800,
                1.0,
                TextDecoration.none),
          ),
          const CustomSpacing(value: 50),
          Container(
            height: h - h / 3.5,
            child: SingleChildScrollView(
              child: Column(
                children: cartData.cartData
                    .map((item) => Container(
                          width: w,
                          height: h / 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: w / 25, vertical: h / 50),
                          padding: EdgeInsets.symmetric(
                              horizontal: w / 20, vertical: h / 100),
                          child: Stack(
                            children: [
                              Center(
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  leading: Image.network(item['image'],
                                      fit: BoxFit.contain),
                                  dense: false,
                                  // isThreeLine: true,
                                  title: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomRowText(
                                          firstText: 'Name: ',
                                          secondText: item['name']),
                                      CustomRowText(
                                          firstText: 'Price: ',
                                          secondText: item['price']),
                                      CustomRowText(
                                          firstText: 'Selected Size: ',
                                          secondText:
                                              item['selected_size'] == null
                                                  ? '-'
                                                  : item['selected_size']
                                                      .toString()),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                // top: 0,
                                bottom: 0,
                                child: IconButton(
                                    onPressed: () {
                                      cartData.removeItem(
                                          item['id'], item['product_type']);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            width: w,
            height: h / 5,
            padding: EdgeInsets.symmetric(horizontal: w / 20, vertical: h / 50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: appTheme.nonStaticGetTextStyle(
                          1.5,
                          const Color.fromRGBO(23, 45, 84, 1),
                          appTheme.mediumTextSize(context),
                          FontWeight.w500,
                          1.0,
                          TextDecoration.none),
                    ),
                    Text.rich(TextSpan(
                        text: cartData.totalPrice.toStringAsFixed(2),
                        style: appTheme.nonStaticGetTextStyle(
                            1.5,
                            const Color.fromRGBO(23, 45, 84, 1),
                            appTheme.mediumTextSize(context) * 1.5,
                            FontWeight.w600,
                            1.0,
                            TextDecoration.none),
                        children: [
                          TextSpan(
                            text: ' EGP',
                            style: appTheme.nonStaticGetTextStyle(
                                1.5,
                                const Color.fromRGBO(23, 45, 84, 1),
                                appTheme.mediumTextSize(context) * 1.5,
                                FontWeight.w600,
                                1.0,
                                TextDecoration.none),
                          )
                        ]))
                  ],
                ),
                buttonData.isLoading['order']!
                    ? const CustomButtonLoading()
                    : TextButton(
                        onPressed: cartData.cartData.isEmpty
                            ? null
                            : () async {
                                buttonData.changeLoadingState('order');
                                UserApiCaller userApiCaller = UserApiCaller();
                                Map<String, dynamic> status =
                                    await userApiCaller.order(
                                        cartData.cartData, cartData.totalPrice);
                                if (status['Err_Flag']) {
                                  buttonData.changeLoadingState('order');
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    lottieAsset:
                                        'assets/animations/38213-error.json',
                                    text: status['Err_Desc'],
                                  );
                                  return;
                                }
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  lottieAsset:
                                      'assets/animations/6951-success.json',
                                  text: 'Order Created Successfully',
                                );
                                cartData.empty();
                                buttonData.changeLoadingState('order');
                                commonData.changeStep(Pages.HomeScreen.index);
                              },
                        style: ButtonStyle(
                            padding: MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: w / 10, vertical: h / 50)),
                            backgroundColor: const MaterialStatePropertyAll<Color>(
                                Color.fromRGBO(23, 45, 84, 1))),
                        child: Text(
                          'Order Now!',
                          style: appTheme.nonStaticGetTextStyle(
                              1.5,
                              Colors.white,
                              appTheme.mediumTextSize(context),
                              FontWeight.w400,
                              1.0,
                              TextDecoration.none),
                        ),
                      )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
