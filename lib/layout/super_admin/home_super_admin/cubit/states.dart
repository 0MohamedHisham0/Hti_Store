abstract class HomeSuperUserStates {}

class HomeSuperUserInitialState extends HomeSuperUserStates {}

class HomeSuperUserLoadingState extends HomeSuperUserStates {}

class HomeSuperUserSuccessState extends HomeSuperUserStates
{
  final HomeSuperUserStates UserModel;

  HomeSuperUserSuccessState(this.UserModel);
}

class HomeSuperUserErrorState extends HomeSuperUserStates
{
  final String error;

  HomeSuperUserErrorState(this.error);
}

class ChangeDropDownMenu extends HomeSuperUserStates {}
