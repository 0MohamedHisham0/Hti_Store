import 'package:hti_store/models/list_user_model.dart';

import '../../../../models/delet_user_model.dart';

abstract class HomeSuppliersStates {}

class HomeSuppliersInitialState extends HomeSuppliersStates {}

class HomeSuppliersLoadingState extends HomeSuppliersStates {}

class HomeSuppliersSuccessState extends HomeSuppliersStates {
  final ListUsers listUsers;

  HomeSuppliersSuccessState(this.listUsers);
}

class HomeSuppliersErrorState extends HomeSuppliersStates {
  final String error;

  HomeSuppliersErrorState(this.error);


}
class HomeSuppliersIsEmpty extends HomeSuppliersStates {

  HomeSuppliersIsEmpty();
}

class ChangeDropDownMenu extends HomeSuppliersStates {

  final String role;

  ChangeDropDownMenu(this.role);
}

class DeleteUserLoadingState extends HomeSuppliersStates {}

class DeleteUserSuccessState extends HomeSuppliersStates {
  final DeleteUserModel deleteModel;

  DeleteUserSuccessState(this.deleteModel);
}

class DeleteUserErrorState extends HomeSuppliersStates {
  final String error;

  DeleteUserErrorState(this.error);
}

class ChangeScreenIndexState extends HomeSuppliersStates {
  ChangeScreenIndexState();
}
