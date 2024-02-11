// ignore_for_file: file_names

import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:ny_shop/GeneralInfo.dart';
import 'package:ny_shop/Models/Product.dart';
import 'package:ny_shop/SharedData/AppTheme.dart';
import 'package:ny_shop/SharedData/CommonData.dart';
import 'package:provider/provider.dart';
import 'CustomSpacing.dart';

//ToDo: Copy Somewhere
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

class CustomProductContainer extends StatefulWidget {
  final Product product;
  const CustomProductContainer({super.key, required this.product});

  @override
  State<CustomProductContainer> createState() => _CustomProductContainerState();
}

class _CustomProductContainerState extends State<CustomProductContainer> {
  static late AppTheme appTheme;
  static late CommonData commonData;
  static late double w, h;
  @override
  Widget build(BuildContext context) {
    commonData = Provider.of<CommonData>(context);
    appTheme = Provider.of<AppTheme>(context);
    w = MediaQuery.sizeOf(context).width;
    h = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: () {
        commonData.setProduct(widget.product);
        commonData.changeStep(Pages.DetailedProductScreen.index);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: h / 100, bottom: h / 100, left: w / 50, right: w / 50),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: h / 3 - h / 50,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: h / 100,
                            bottom: h / 100,
                            left: w / 50,
                            right: w / 50),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            widget.product.mainImage,
                            // height: h/4,
                            width: w,
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.product.hasDiscount
                  ? Positioned(
                      top: 0,
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w / 40, vertical: h / 100),
                        child: Center(
                            child: AnimateIcon(
                          toolTip: 'Has Discount',
                          key: UniqueKey(),
                          onTap: () {},
                          iconType: IconType.continueAnimation,
                          height: 70,
                          width: 60,
                          color: Colors.red.shade900,
                          animateIcon: AnimateIcons.discount,
                        )),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          Text(
            widget.product.name.capitalize(),
            style: appTheme.nonStaticGetTextStyle(
                1.5,
                const Color.fromRGBO(24, 44, 84, 1),
                appTheme.mediumTextSize(context),
                FontWeight.w900,
                1.0,
                TextDecoration.none),
          ),
          const CustomSpacing(value: 100),
          Text.rich(TextSpan(
              text: widget.product.price,
              style: appTheme.nonStaticGetTextStyle(
                  1.5,
                  widget.product.hasDiscount
                      ? Colors.grey
                      : const Color.fromRGBO(
                          23,
                          44,
                          84,
                          1,
                        ),
                  widget.product.hasDiscount
                      ? appTheme.mediumTextSize(context) * 1
                      : appTheme.mediumTextSize(context) * 1.2,
                  FontWeight.w600,
                  1.0,
                  widget.product.hasDiscount
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
              children: [
                TextSpan(
                    text: ' EGP',
                    style: appTheme.nonStaticGetTextStyle(
                        1.5,
                        widget.product.hasDiscount
                            ? Colors.grey
                            : const Color.fromRGBO(
                                23,
                                44,
                                84,
                                1,
                              ),
                        widget.product.hasDiscount
                            ? appTheme.mediumTextSize(context) * 1
                            : appTheme.mediumTextSize(context) * 1.2,
                        FontWeight.w600,
                        1.0,
                        widget.product.hasDiscount
                            ? TextDecoration.lineThrough
                            : TextDecoration.none))
              ])),
          widget.product.hasDiscount
              ? Text.rich(TextSpan(
                  text: widget.product.priceAfterDiscount,
                  style: appTheme.nonStaticGetTextStyle(
                      1.5,
                      const Color.fromRGBO(
                        23,
                        44,
                        84,
                        1,
                      ),
                      appTheme.mediumTextSize(context) * 1.2,
                      FontWeight.w900,
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
                              appTheme.mediumTextSize(context) * 1.2,
                              FontWeight.w900,
                              1.0,
                              TextDecoration.none))
                    ]))
              : const SizedBox(),
          const CustomSpacing(value: 100),
        ],
      ),
    );
  }
}
