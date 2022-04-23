import 'package:hti_store/models/product_model.dart';

import '../../../../models/list_product_model.dart';

abstract class OutStoreStates {}

class OutStoreInitialState extends OutStoreStates {}

class OutStoreLoadingState extends OutStoreStates {}

class OutStoreSuccessState extends OutStoreStates {
  final ListProductModel OutStoreProducts;

  OutStoreSuccessState(this.OutStoreProducts);
}

class OutStoreErrorState extends OutStoreStates {
  final String errorMessage;

  OutStoreErrorState(this.errorMessage);
}

class OutStoreEmptyState extends OutStoreStates {}

class OutStoreChangeBottomMenuState extends OutStoreStates {}


class OutStoreChangeProductLoadingState extends OutStoreStates {}

class OutStoreChangeProductSuccessState extends OutStoreStates {
  final ProductModel productModel;

  OutStoreChangeProductSuccessState(this.productModel);
}

class OutStoreChangeProductErrorState extends OutStoreStates {
  final String errorMessage;

  OutStoreChangeProductErrorState(this.errorMessage);
}
