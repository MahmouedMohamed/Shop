// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:ny_shop/ApiCallers/ProductApiCaller.dart';
import 'package:ny_shop/CustomWidgets/CustomLoading.dart';
import 'package:ny_shop/CustomWidgets/CustomProductContainer.dart';
import 'package:ny_shop/CustomWidgets/LoadingProductContainer.dart';
import 'package:ny_shop/Models/Product.dart';
import 'package:ny_shop/SharedData/AppTheme.dart';
import 'package:ny_shop/SharedData/CacheManager.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  final String type;
  const ProductsScreen({super.key, required this.type});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product>? products;
  int current = 0;
  static late AppTheme appTheme;
  int currentPage = 1;
  int itemCount = 0;
  late int total;
  CacheManager cacheManager = CacheManager();

  @override
  initState() {
    super.initState();
    initProducts();
  }

  initProducts() async {
    List<Product> addedProducts;

    if (cacheManager.hasData(widget.type)) {
      products ??= [];
      products = cacheManager.getData(widget.type);
      total = cacheManager.getData('${widget.type} total');
      currentPage = cacheManager.getData('${widget.type} currentPage');
      itemCount = cacheManager.getData('${widget.type} itemCount');
      if (currentPage * 10 >= itemCount) {
        return false;
      }
    }
    addedProducts = await getGeneratedProducts();
    setState(() {
      products = [];
      products!.addAll(addedProducts);
    });
  }

  Widget getProductsBody(context) {
    if (products == null) {
      return Container(alignment: Alignment.center, child: const CustomLoading());
    }
    if (products!.isEmpty) {
      return Center(
        child: Text(
          'No Products Available.',
          style: appTheme.nonStaticGetTextStyle(
              1.5,
              const Color.fromRGBO(24, 44, 84, 1),
              appTheme.mediumTextSize(context),
              FontWeight.w100,
              1.0,
              TextDecoration.none),
        ),
      );
    }
    return NotificationListener<ScrollEndNotification>(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.54),
        shrinkWrap: false,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          if (index == products!.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final item = products![index];
          return CustomProductContainer(product: item);
        },
        itemCount: itemCount,
      ),
      onNotification: (scrollEnd) {
        if (scrollEnd.metrics.atEdge && scrollEnd.metrics.pixels > 0) {
          if (currentPage * 10 >= itemCount) {
            return false;
          }
          currentPage++;
          getGeneratedProducts();
        }
        return true;
      },
    );
  }

  List<Widget> getLoadingContainerIfExists() {
    return products!.isEmpty || products!.length < total
        ? <Widget>[const LoadingProductContainer()]
        : <Widget>[];
  }

  Future<List<Product>> getGeneratedProducts(
      [List<String>? bookmarkedProductsIDs]) async {
    ProductApiCaller productApiCaller = ProductApiCaller();
    late Map<String, dynamic> status;
    status = await productApiCaller.getAll(widget.type, currentPage);
    products ??= [];
    products!.addAll(status['Values']);
    if (!status['Err_Flag']) {
      setState(() {
        total = status['total'];
        itemCount = total > 10 * currentPage ? 10 * currentPage + 1 : total;
      });
      cacheManager.setData(widget.type, products);
      cacheManager.setData('${widget.type} total', total);
      cacheManager.setData('${widget.type} currentPage', currentPage);
      cacheManager.setData('${widget.type} itemCount', itemCount);
      return status['Values'];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    appTheme = Provider.of<AppTheme>(context);
    // appLanguage = Provider.of<AppLanguage>(context);
    return getProductsBody(context);
  }
}
