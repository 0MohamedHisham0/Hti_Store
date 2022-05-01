class OrdersModel {
  bool? status;
  String? message;
  List<OrderData>? data;

  OrdersModel({this.status, this.message, this.data});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(OrderData.fromJson(v));
      });
    }
  }

}

class OrderData {
  int? id;
  List<OrderedProducts>? orderedProducts;
  String? branch;
  String? acceptFromManagerStore;
  String? notes;
  String? dateOfOrder;
  String? dateOfsent;
  int? userId;
  String? whoCreatedOrder;
  String? whoAcceptOrder;

  OrderData(
      {this.id,
        this.orderedProducts,
        this.branch,
        this.acceptFromManagerStore,
        this.notes,
        this.dateOfOrder,
        this.dateOfsent,
        this.userId,
        this.whoCreatedOrder,
        this.whoAcceptOrder});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orderedProducts'] != null) {
      orderedProducts = <OrderedProducts>[];
      json['orderedProducts'].forEach((v) {
        orderedProducts!.add(new OrderedProducts.fromJson(v));
      });
    }
    branch = json['branch'];
    acceptFromManagerStore = json['acceptFromManagerStore'];
    notes = json['notes'];
    dateOfOrder = json['dateOfOrder'];
    dateOfsent = json['dateOfsent'];
    userId = json['userId'];
    whoCreatedOrder = json['whoCreatedOrder'];
    whoAcceptOrder = json['whoAcceptOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.orderedProducts != null) {
      data['orderedProducts'] = this.orderedProducts?.map((v) => v.toJson()).toList();
    }
    data['branch'] = this.branch;
    data['acceptFromManagerStore'] = this.acceptFromManagerStore;
    data['notes'] = this.notes;
    data['dateOfOrder'] = this.dateOfOrder;
    data['dateOfsent'] = this.dateOfsent;
    data['userId'] = this.userId;
    data['whoCreatedOrder'] = this.whoCreatedOrder;
    data['whoAcceptOrder'] = this.whoAcceptOrder;
    return data;
  }

}

class OrderedProducts {
  String? id;
  String? count;
  String? productname;

  OrderedProducts({this.id, this.count, this.productname});

  OrderedProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count = json['count'];
    productname = json['productname'];
  }

  // to jason
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['count'] = this.count;
    data['productname'] = this.productname;
    return data;
  }
}
