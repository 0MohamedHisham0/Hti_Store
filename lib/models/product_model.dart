class ProductModel {
  bool? status;
  String? message;
  ProductData? data;

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProductData.fromJson(json['data']) : null;
  }
}

class ProductData {
  int? id;
  String? name;
  int? count;
  String? nameofsupplier;
  String? phoneofsupplier;
  String? supplieredCompany;
  String? description;
  String? type;
  String? status;
  String? storeId;
  String? createdAt;

  // named constructor
  ProductData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    id = json['id'];
    nameofsupplier = json['nameofsupplier'];
    phoneofsupplier = json['roles'];
    supplieredCompany = json['supplieredCompany'];
    description = json['description'];
    type = json['type'];
    status = json['status'];
    storeId = json['storeId'];
    createdAt = json['createdAt'];
  }
}
