import '../../../../models/list_product_model.dart';

abstract class InStoreStates {}

class InStoreInitialState extends InStoreStates {}

class InStoreLoadingState extends InStoreStates {}

class InStoreSuccessState extends InStoreStates {
  final ListProductModel inStoreProducts;

  InStoreSuccessState(this.inStoreProducts);
}

class InStoreErrorState extends InStoreStates {
  final String errorMessage;

  InStoreErrorState(this.errorMessage);
}

class InStoreEmptyState extends InStoreStates {}

class InStoreChangeBottomMenuState extends InStoreStates {}

