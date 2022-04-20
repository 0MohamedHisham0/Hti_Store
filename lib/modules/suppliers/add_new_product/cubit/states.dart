import 'package:hti_store/models/list_user_model.dart';
import 'package:hti_store/models/product_model.dart';

import '../../../../models/delet_user_model.dart';

abstract class AddNewProductStates {}

class AddNewProductInitialState extends AddNewProductStates {}

class AddNewProductLoadingState extends AddNewProductStates {}

class AddNewProductSuccessState extends AddNewProductStates {
  final ProductModel listUsers;

  AddNewProductSuccessState(this.listUsers);
}

class AddNewProductErrorState extends AddNewProductStates {
  final String error;

  AddNewProductErrorState(this.error);
}

class AddNewProductIsEmpty extends AddNewProductStates {
  AddNewProductIsEmpty();
}

class ChangeDropDownMenu extends AddNewProductStates {
  final String role;

  ChangeDropDownMenu(this.role);
}

class DeleteUserLoadingState extends AddNewProductStates {}

class DeleteUserSuccessState extends AddNewProductStates {
  final DeleteUserModel deleteModel;

  DeleteUserSuccessState(this.deleteModel);
}

class DeleteUserErrorState extends AddNewProductStates {
  final String error;

  DeleteUserErrorState(this.error);
}

class AddNewProductChangeNumberPickedState extends AddNewProductStates {
  AddNewProductChangeNumberPickedState();
}

class AddNewProductChangeMenuState extends AddNewProductStates {
  AddNewProductChangeMenuState();
}
