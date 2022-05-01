import 'package:hti_store/models/orders_model.dart';

import '../../../../models/delet_user_model.dart';

abstract class OrdersStates {}

class OrdersInitialState extends OrdersStates {}

class OrdersLoadingState extends OrdersStates {}

class OrdersSuccessState extends OrdersStates {
  final OrdersModel order;

  OrdersSuccessState(this.order);
}

class OrdersErrorState extends OrdersStates {
  final String error;

  OrdersErrorState(this.error);
}

class UpdateOrderSuccessState extends OrdersStates {
  final String state;

  UpdateOrderSuccessState(this.state);
}

class UpdateOrderErrorState extends OrdersStates {
  final String error;

  UpdateOrderErrorState(this.error);
}

class OrdersIsEmpty extends OrdersStates {
  OrdersIsEmpty();
}

class ChangeDropDownMenu extends OrdersStates {
  final String role;

  ChangeDropDownMenu(this.role);
}

class DeleteUserLoadingState extends OrdersStates {}
class InStoreChangeBottomMenuState extends OrdersStates {}

class DeleteUserSuccessState extends OrdersStates {
  final DeleteUserModel deleteModel;

  DeleteUserSuccessState(this.deleteModel);
}

class DeleteUserErrorState extends OrdersStates {
  final String error;

  DeleteUserErrorState(this.error);
}

class ChangeScreenIndexState extends OrdersStates {
  ChangeScreenIndexState();
}
