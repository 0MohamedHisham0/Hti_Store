abstract class UserProfileStates {}

class UserProfileInitialState extends UserProfileStates {}

class UserProfileLoadingState extends UserProfileStates {}

class UserProfileSuccessState extends UserProfileStates
{
  final UserProfileStates UserModel;

  UserProfileSuccessState(this.UserModel);
}

class UserProfileErrorState extends UserProfileStates
{
  final String error;

  UserProfileErrorState(this.error);
}

class ChangeDropDownMenu extends UserProfileStates {}
