import 'package:hti_store/models/list_user_model.dart';

import '../../../../models/delet_user_model.dart';

abstract class HomeSuperUserStates {}

class HomeSuperUserInitialState extends HomeSuperUserStates {}

class HomeSuperUserLoadingState extends HomeSuperUserStates {}

class HomeSuperUserSuccessState extends HomeSuperUserStates {
  final ListUsers listUsers;

  HomeSuperUserSuccessState(this.listUsers);
}

class HomeSuperUserErrorState extends HomeSuperUserStates {
  final String error;

  HomeSuperUserErrorState(this.error);


}
class HomeSuperUserIsEmpty extends HomeSuperUserStates {

  HomeSuperUserIsEmpty();
}

class ChangeDropDownMenu extends HomeSuperUserStates {

  final String role;

  ChangeDropDownMenu(this.role);
}

class DeleteUserLoadingState extends HomeSuperUserStates {}

class DeleteUserSuccessState extends HomeSuperUserStates {
  final DeleteUserModel deleteModel;

  DeleteUserSuccessState(this.deleteModel);
}

class DeleteUserErrorState extends HomeSuperUserStates {
  final String error;

  DeleteUserErrorState(this.error);
}
