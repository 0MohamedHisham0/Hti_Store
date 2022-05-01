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
        data!.add(new OrderData.fromJson(v));
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

}
