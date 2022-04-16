import '../../../../models/login_model.dart';

abstract class AddUserStates {}

class AddUserInitialState extends AddUserStates {}

class AddUserLoadingState extends AddUserStates {}

class AddUserSuccessState extends AddUserStates {
  final LoginModel addUserModel;

  AddUserSuccessState(this.addUserModel);
}

class AddUserErrorState extends AddUserStates {
  final String error;

  AddUserErrorState(this.error);
}

class UpdateUserRoleLoadingState extends AddUserStates {}

class UpdateUserRoleSuccessState extends AddUserStates {
  final LoginModel updateModel;

  UpdateUserRoleSuccessState(this.updateModel);
}

class UpdateUserRoleErrorState extends AddUserStates {
  final String error;

  UpdateUserRoleErrorState(this.error);
}

class ChangePasswordVisibilityState extends AddUserStates {}

class ChangeRoleState extends AddUserStates {}

class ChangeBranchState extends AddUserStates {}

class ChangeSectionState extends AddUserStates {}
