import 'package:hti_store/models/list_user_model.dart';
import 'package:hti_store/models/product_model.dart';

import '../../../../models/delet_user_model.dart';

abstract class UpdateProductStates {}

class UpdateProductInitialState extends UpdateProductStates {}

class UpdateProductLoadingState extends UpdateProductStates {}

class UpdateProductSuccessState extends UpdateProductStates {
  final ProductModel listUsers;

  UpdateProductSuccessState(this.listUsers);
}

class UpdateProductErrorState extends UpdateProductStates {
  final String error;

  UpdateProductErrorState(this.error);
}

class UpdateProductIsEmpty extends UpdateProductStates {
  UpdateProductIsEmpty();
}

class ChangeDropDownMenu extends UpdateProductStates {
  final String role;

  ChangeDropDownMenu(this.role);
}

class DeleteUserLoadingState extends UpdateProductStates {}

class DeleteUserSuccessState extends UpdateProductStates {
  final DeleteUserModel deleteModel;

  DeleteUserSuccessState(this.deleteModel);
}

class DeleteUserErrorState extends UpdateProductStates {
  final String error;

  DeleteUserErrorState(this.error);
}

class UpdateProductChangeNumberPickedState extends UpdateProductStates {
  UpdateProductChangeNumberPickedState();
}

class UpdateProductChangeMenuState extends UpdateProductStates {
  UpdateProductChangeMenuState();
}
