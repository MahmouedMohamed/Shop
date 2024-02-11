import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ny_shop/CustomWidgets/CustomSpacing.dart';
import 'package:ny_shop/Models/Product.dart';
import 'package:ny_shop/Session/SessionManager.dart';
import 'package:ny_shop/SharedData/AppTheme.dart';
import 'package:ny_shop/SharedData/CartData.dart';
import 'package:ny_shop/SharedData/CommonData.dart';
import 'package:provider/provider.dart';

extension StringExtension on String {
  String capitalize() {
    if (RegExp(r'^[A-Z]+$').hasMatch(this)) {
      return this;
    }
    List<String> words = this.split(" ");
    String word = "";
    for (int index = 0; index < words.length; index++) {
      word +=
          "${words[index][0].toUpperCase()}${words[index].substring(1).toLowerCase()}";
      if (index != words.length - 1) {
        word += " ";
      }
    }
    return word;
  }
}

class DetailedProductScreen extends StatelessWidget {
  static late CommonData commonData;
  static late AppTheme appTheme;
  static late CartData cartData;
  static final SessionManager sessionManager = SessionManager();
  const DetailedProductScreen({super.key});

  static late double w, h;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.sizeOf(context).width;
    h = MediaQuery.sizeOf(context).height;
    commonData = Provider.of<CommonData>(context);
    appTheme = Provider.of<AppTheme>(context);
    cartData = Provider.of<CartData>(context);
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: h / 2.5,
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.5)),
                  child: Stack(
                    children: [
                      ClipRect(
                          child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: Padding(
                                  padding: EdgeInsets.only(top: h / 50),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        height: h / 2.5,
                                        onPageChanged: (index, reason) {
                                          commonData.updateIndex(index);
                                        },
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                        enableInfiniteScroll: true,
                                        viewportFraction: 1),
                                    items: commonData.product.images
                                        .map((image) => Image.network(
                                              image,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Couldn\'t Load Image',
                                                    style: appTheme
                                                        .nonStaticGetTextStyle(
                                                            1.5,
                                                            Colors.red[200],
                                                            appTheme
                                                                .mediumTextSize(
                                                                    context),
                                                            FontWeight.w500,
                                                            1.0,
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                );
                                              },
                                            ))
                                        .toList(),
                                  )))),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          width: w,
                          height: h / 25,
                          color: Colors.black.withOpacity(0.2),
                          child: ClipRect(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 10.0, sigmaY: 50.0),
                              child: DotsIndicator(
                                dotsCount: commonData.product.images.length,
                                position: commonData.currentIndex,
                                decorator: DotsDecorator(
                                    activeSize: const Size(18.0, 9.0),
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    activeColor:
                                        const Color.fromRGBO(23, 45, 84, 1)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSpacing(value: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: w / 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          commonData.product.hasDiscount
                              ? Text.rich(TextSpan(
                                  text: commonData.product.priceAfterDiscount,
                                  style: appTheme.nonStaticGetTextStyle(
                                      1.5,
                                      const Color.fromRGBO(
                                        23,
                                        44,
                                        84,
                                        1,
                                      ),
                                      appTheme.largeTextSize(context),
                                      FontWeight.w800,
                                      1.0,
                                      TextDecoration.none),
                                  children: [
                                      TextSpan(
                                        text: ' EGP',
                                        style: appTheme.nonStaticGetTextStyle(
                                            1.5,
                                            const Color.fromRGBO(
                                              23,
                                              44,
                                              84,
                                              1,
                                            ),
                                            appTheme.largeTextSize(context),
                                            FontWeight.w800,
                                            1.0,
                                            TextDecoration.none),
                                      )
                                    ]))
                              : const SizedBox(),
                          commonData.product.hasDiscount
                              ? SizedBox(
                                  width: w / 25,
                                )
                              : const SizedBox(),
                          Text.rich(TextSpan(
                              text: commonData.product.price,
                              style: appTheme.nonStaticGetTextStyle(
                                  1.5,
                                  commonData.product.hasDiscount
                                      ? Colors.grey
                                      : const Color.fromRGBO(
                                          23,
                                          44,
                                          84,
                                          1,
                                        ),
                                  commonData.product.hasDiscount
                                      ? appTheme.mediumTextSize(context)
                                      : appTheme.largeTextSize(context),
                                  FontWeight.w800,
                                  1.0,
                                  commonData.product.hasDiscount
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                              children: [
                                TextSpan(
                                    text: ' EGP',
                                    style: appTheme.nonStaticGetTextStyle(
                                        1.5,
                                        commonData.product.hasDiscount
                                            ? Colors.grey
                                            : const Color.fromRGBO(
                                                23,
                                                44,
                                                84,
                                                1,
                                              ),
                                        commonData.product.hasDiscount
                                            ? appTheme.mediumTextSize(context)
                                            : appTheme.largeTextSize(context),
                                        FontWeight.w800,
                                        1.0,
                                        commonData.product.hasDiscount
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none))
                              ])),
                        ],
                      ),
                      const CustomSpacing(value: 60),
                      Text(
                        commonData.product.name.capitalize(),
                        style: appTheme.nonStaticGetTextStyle(
                            1.5,
                            const Color.fromRGBO(
                              23,
                              44,
                              84,
                              1,
                            ),
                            appTheme.largeTextSize(context),
                            FontWeight.w600,
                            1.0,
                            TextDecoration.none),
                      ),
                      const CustomSpacing(value: 30),
                      Text(
                        commonData.product.description,
                        style: appTheme.nonStaticGetTextStyle(
                            1.5,
                            Colors.grey,
                            appTheme.mediumTextSize(context),
                            FontWeight.w600,
                            1.0,
                            TextDecoration.none),
                      ),
                    ],
                  ),
                ),
                const CustomSpacing(value: 10),
                if (commonData.product.hasSizes)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: w / 25),
                    child: Row(
                      children: [
                        Text(
                          'Size:',
                          style: appTheme.nonStaticGetTextStyle(
                              1.5,
                              Colors.grey,
                              appTheme.mediumTextSize(context) * 1.5,
                              FontWeight.w400,
                              1.0,
                              TextDecoration.none),
                        ),
                        SizedBox(
                          width: w / 25,
                        ),
                        ToggleButtons(
                            selectedColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            isSelected: List.generate(
                              commonData.product.sizes!.length,
                              (index) {
                                if (index == commonData.chosenSizeIndex) {
                                  return true;
                                }
                                return false;
                              },
                            ),
                            onPressed: (index) {
                              commonData.updateChosenSize(
                                  index, commonData.product.sizes![index]);
                            },
                            renderBorder: false,
                            children: List.generate(
                                commonData.product.sizes!.length,
                                (index) => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            index == commonData.chosenSizeIndex
                                                ? const Color.fromRGBO(
                                                    228, 174, 138, 1)
                                                : const Color.fromRGBO(
                                                    240, 244, 247, 1),
                                      ),
                                      padding: EdgeInsets.all(h / 80),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: w / 50),
                                      child: Text(
                                        commonData.product.sizes![index]
                                            .toString(),
                                        style: appTheme.nonStaticGetTextStyle(
                                            1.5,
                                            index == commonData.chosenSizeIndex
                                                ? Colors.white
                                                : const Color.fromRGBO(
                                                    23, 45, 84, 1),
                                            appTheme.mediumTextSize(context),
                                            FontWeight.w600,
                                            1.0,
                                            TextDecoration.none),
                                      ),
                                    )))
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                if (sessionManager.user?.phoneNumber == null) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    lottieAsset: 'assets/animations/38213-error.json',
                    text:
                        "You Must Add Your Phone Number to Your Profile Before Ordering!",
                  );
                  return;
                }
                if (sessionManager.user?.address == null) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    lottieAsset: 'assets/animations/38213-error.json',
                    text:
                        "You Must Add Your Address to Your Profile Before Ordering!",
                  );
                  return;
                }
                if (!cartData.hasItem(
                        commonData.product.id, commonData.product.type) &&
                    commonData.product.hasSizes &&
                    commonData.chosenSize == null) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    lottieAsset: 'assets/animations/38213-error.json',
                    text: "You Must Choose Size Before Ordering!",
                  );
                  return;
                }
                cartData.addItem({
                  'id': commonData.product.id,
                  'image': commonData.product.mainImage,
                  'name': commonData.product.name,
                  'product_type': commonData.product.type,
                  'selected_size': commonData.chosenSize,
                  'price': commonData.product.hasDiscount
                      ? commonData.product.priceAfterDiscount
                      : commonData.product.price,
                });
              },
              child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(23, 45, 84, 1),
                  ),
                  padding: EdgeInsets.all(h / 80),
                  margin: EdgeInsets.symmetric(horizontal: w / 50),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        cartData.hasItem(
                                commonData.product.id, commonData.product.type)
                            ? Icons.check
                            : Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
