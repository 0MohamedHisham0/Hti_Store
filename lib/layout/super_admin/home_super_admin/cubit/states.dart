import 'package:hti_store/models/list_user_model.dart';

abstract class HomeSuperUserStates {}

class HomeSuperUserInitialState extends HomeSuperUserStates {}

class HomeSuperUserLoadingState extends HomeSuperUserStates {}

class HomeSuperUserSuccessState extends HomeSuperUserStates
{
  final ListUsers listUsers;

  HomeSuperUserSuccessState(this.listUsers);
}

class HomeSuperUserErrorState extends HomeSuperUserStates
{
  final String error;

  HomeSuperUserErrorState(this.error);
}

class ChangeDropDownMenu extends HomeSuperUserStates {}
