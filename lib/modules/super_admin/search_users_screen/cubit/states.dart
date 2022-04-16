import 'package:hti_store/models/list_user_model.dart';

import '../../../../models/delet_user_model.dart';

abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class SearchLoadingState extends SearchStates {}

class SearchSuccessState extends SearchStates {
  final ListUsers listUsers;

  SearchSuccessState(this.listUsers);
}

class SearchErrorState extends SearchStates {
  final String error;

  SearchErrorState(this.error);


}
class SearchIsEmpty extends SearchStates {

  SearchIsEmpty();
}

class ChangeDropDownMenu extends SearchStates {

  final String role;

  ChangeDropDownMenu(this.role);
}

class DeleteUserLoadingState extends SearchStates {}

class DeleteUserSuccessState extends SearchStates {
  final DeleteUserModel deleteModel;

  DeleteUserSuccessState(this.deleteModel);
}

class DeleteUserErrorState extends SearchStates {
  final String error;

  DeleteUserErrorState(this.error);
}
