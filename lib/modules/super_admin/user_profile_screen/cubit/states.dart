import 'package:hti_store/models/delet_user_model.dart';
import 'package:hti_store/models/login_model.dart';

abstract class UserProfileStates {}

class UserProfileInitialState extends UserProfileStates {}

class UserProfileLoadingState extends UserProfileStates {}

class UserProfileSuccessState extends UserProfileStates {
  final UserData UserModel;

  UserProfileSuccessState(this.UserModel);
}

class UserProfileErrorState extends UserProfileStates {
  final String error;

  UserProfileErrorState(this.error);
}

class UpdateUserRoleLoadingState extends UserProfileStates {}

class UpdateUserRoleSuccessState extends UserProfileStates {
  final UserData updateModel;

  UpdateUserRoleSuccessState(this.updateModel);
}

class UpdateUserRoleErrorState extends UserProfileStates {
  final String error;

  UpdateUserRoleErrorState(this.error);
}

class DeleteUserLoadingState extends UserProfileStates {}

class DeleteUserSuccessState extends UserProfileStates {
  final DeleteUserModel deleteModel;

  DeleteUserSuccessState(this.deleteModel);
}

class DeleteUserErrorState extends UserProfileStates {
  final String error;

  DeleteUserErrorState(this.error);
}

class ChangeDropDownMenu extends UserProfileStates {}

class ChangeRoleState extends UserProfileStates {}

class ChangeBranchState extends UserProfileStates {}

class ChangeSectionState extends UserProfileStates {}
