import 'package:hti_store/models/list_product_model.dart';
import 'package:hti_store/models/list_user_model.dart';

import '../../../../models/delet_user_model.dart';

abstract class AllProductsStates {}

class AllProductsInitialState extends AllProductsStates {}

class AllProductsLoadingState extends AllProductsStates {}

class AllProductsSuccessState extends AllProductsStates {
  final ListProductModel listProdutcts;

  AllProductsSuccessState(this.listProdutcts);
}

class AllProductsErrorState extends AllProductsStates {
  final String error;

  AllProductsErrorState(this.error);
}

class AllProductsIsEmpty extends AllProductsStates {
  AllProductsIsEmpty();
}

class ChangeDropDownMenu extends AllProductsStates {
  final String role;

  ChangeDropDownMenu(this.role);
}

class DeleteUserLoadingState extends AllProductsStates {}

class DeleteUserSuccessState extends AllProductsStates {
  final DeleteUserModel deleteModel;

  DeleteUserSuccessState(this.deleteModel);
}

class DeleteUserErrorState extends AllProductsStates {
  final String error;

  DeleteUserErrorState(this.error);
}

class ChangeScreenIndexState extends AllProductsStates {
  ChangeScreenIndexState();
}
