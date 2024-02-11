// ignore_for_file: file_names

class Product {
  String id;
  String name;
  String type;
  String shortDescription;
  String description;
  bool hasDiscount;
  String price;
  String? priceAfterDiscount;
  String mainImage;
  List<dynamic> images;
  bool hasSizes;
  List<dynamic>? sizes;
  Product(
      this.id,
      this.name,
      this.type,
      this.shortDescription,
      this.description,
      this.hasDiscount,
      this.price,
      this.priceAfterDiscount,
      this.mainImage,
      this.images,
      this.hasSizes,
      this.sizes);
}