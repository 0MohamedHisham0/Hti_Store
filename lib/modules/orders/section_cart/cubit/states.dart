import 'package:hti_store/models/orders_model.dart';

abstract class SectionCartStates {}

class SectionCartInitialState extends SectionCartStates {}

class SectionCartLoadingState extends SectionCartStates {}

class SectionCartRemoveProductState extends SectionCartStates {}

class SectionCartSuccessState extends SectionCartStates {
  final OrderData orderModel;

  SectionCartSuccessState(this.orderModel);
}

class SectionCartErrorState extends SectionCartStates {
  final String error;

  SectionCartErrorState(this.error);
}

class DeleteOrderLoadingState extends SectionCartStates {}

class DeleteOrderSuccessState extends SectionCartStates {}

class DeleteOrderErrorState extends SectionCartStates {
  final String error;

  DeleteOrderErrorState(this.error);
}

class CreateOrderLoadingState extends SectionCartStates {}

class CreateOrderSuccessState extends SectionCartStates {
  final OrderData orderData;

  CreateOrderSuccessState(this.orderData);
}

class CreateOrderErrorState extends SectionCartStates {
  final String error;

  CreateOrderErrorState(this.error);
}

class SectionCartClearCartState extends SectionCartStates {
  SectionCartClearCartState();
}
