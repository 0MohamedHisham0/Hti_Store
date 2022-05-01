import '../../../../models/list_product_model.dart';

abstract class InStoreSectionStates {}

class InStoreSectionInitialState extends InStoreSectionStates {}

class InStoreSectionLoadingState extends InStoreSectionStates {}

class InStoreSectionSuccessState extends InStoreSectionStates {
  final ListProductModel InStoreSectionProducts;

  InStoreSectionSuccessState(this.InStoreSectionProducts);
}

class InStoreSectionErrorState extends InStoreSectionStates {
  final String errorMessage;

  InStoreSectionErrorState(this.errorMessage);
}

class InStoreSectionEmptyState extends InStoreSectionStates {}

class InStoreSectionChangeBottomMenuState extends InStoreSectionStates {}

