import 'package:hti_store/models/login_model.dart';

import '../../../../models/orders_model.dart';
import '../../../../models/product_model.dart';

abstract class ProductOrderDetailsStates {}

class ProductOrderDetailsInitialState extends ProductOrderDetailsStates {}

class ProductOrderDetailsLoadingState extends ProductOrderDetailsStates {}

class ProductOrderDetailsSuccessState extends ProductOrderDetailsStates {
  final ProductModel productOrderModel;

  ProductOrderDetailsSuccessState(this.productOrderModel);
}

class ProductOrderDetailsErrorState extends ProductOrderDetailsStates {
  final String error;

  ProductOrderDetailsErrorState(this.error);
}


class DeleteProductOrderLoadingState extends ProductOrderDetailsStates {}

class DeleteProductOrderSuccessState extends ProductOrderDetailsStates {

}

class DeleteProductOrderErrorState extends ProductOrderDetailsStates {
  final String error;

  DeleteProductOrderErrorState(this.error);
}


class ChangeOrderCountState extends ProductOrderDetailsStates {
  final int count;

  ChangeOrderCountState(this.count);
}

