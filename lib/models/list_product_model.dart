import 'package:hti_store/models/product_model.dart';

class ListProductModel {
  bool? status;
  String? message;
  ListProductData? data;

  ListProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ListProductData.fromJson(json['data'])
        : null;
  }
}

class ListProductData {
  List<ProductData>? data = [];

  ListProductData.fromJson(List<dynamic> json) {
    for (var element in json) {
      data!.add(ProductData.fromJson(element));
    }
  }
}
