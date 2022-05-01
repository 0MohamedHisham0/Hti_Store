class CreateOrderModel {
  CreateOrderModel({
    required this.notes,
    required this.orderedProducts,
  });

  late final String notes;
  late final List<OrderedProductsCreated> orderedProducts;

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    notes = json['notes'];
    orderedProducts = List.from(json['orderedProducts'])
        .map((e) => OrderedProductsCreated.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notes'] = notes;
    _data['orderedProducts'] = orderedProducts.map((e) => e.toJson()).toList();
    return _data;
  }
}

class OrderedProductsCreated {
  OrderedProductsCreated({
    required this.id,
    required this.count,
    required this.productname,
  });

  late String id;
  late String count;
  late String productname;

  OrderedProductsCreated.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count = json['count'];
    productname = json['productname'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['count'] = count;
    _data['productname'] = productname;
    return _data;
  }
}
