import 'package:hti_store/models/login_model.dart';
import 'package:hti_store/models/orders_model.dart';

abstract class OrderDetailsStates {}

class OrderDetailsInitialState extends OrderDetailsStates {}

class OrderDetailsLoadingState extends OrderDetailsStates {}

class OrderDetailsSuccessState extends OrderDetailsStates {
  final OrderData orderModel;

  OrderDetailsSuccessState(this.orderModel);
}

class OrderDetailsErrorState extends OrderDetailsStates {
  final String error;

  OrderDetailsErrorState(this.error);
}


class DeleteOrderLoadingState extends OrderDetailsStates {}

class DeleteOrderSuccessState extends OrderDetailsStates {

}

class DeleteOrderErrorState extends OrderDetailsStates {
  final String error;

  DeleteOrderErrorState(this.error);
}

