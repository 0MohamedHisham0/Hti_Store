import 'package:hti_store/models/list_product_model.dart';
import '../../../../models/delet_user_model.dart';

abstract class SearchProductStates {}

class SearchInitialState extends SearchProductStates {}

class SearchLoadingState extends SearchProductStates {}

class SearchSuccessState extends SearchProductStates {
  final ListProductModel listUsers;

  SearchSuccessState(this.listUsers);
}

class SearchErrorState extends SearchProductStates {
  final String error;

  SearchErrorState(this.error);


}
class SearchIsEmpty extends SearchProductStates {

  SearchIsEmpty();
}

class ChangeDropDownMenu extends SearchProductStates {

  final String role;

  ChangeDropDownMenu(this.role);
}

class DeleteUserLoadingState extends SearchProductStates {}

class DeleteUserSuccessState extends SearchProductStates {
  final DeleteUserModel deleteModel;

  DeleteUserSuccessState(this.deleteModel);
}

class DeleteUserErrorState extends SearchProductStates {
  final String error;

  DeleteUserErrorState(this.error);
}
