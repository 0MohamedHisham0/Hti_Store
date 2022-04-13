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

class ChangeDropDownMenu extends UserProfileStates {}
