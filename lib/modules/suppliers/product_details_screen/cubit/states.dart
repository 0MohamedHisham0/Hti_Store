import 'package:hti_store/models/login_model.dart';
import 'package:hti_store/models/product_model.dart';

abstract class ProductDetailsStates {}

class ProductDetailsInitialState extends ProductDetailsStates {}

class ProductDetailsLoadingState extends ProductDetailsStates {}

class ProductDetailsSuccessState extends ProductDetailsStates {
  final ProductModel productModel;

  ProductDetailsSuccessState(this.productModel);
}

class ProductDetailsErrorState extends ProductDetailsStates {
  final String error;

  ProductDetailsErrorState(this.error);
}

class UpdateProductLoadingState extends ProductDetailsStates {}

class UpdateProductSuccessState extends ProductDetailsStates {
  final ProductModel productModel;

  UpdateProductSuccessState(this.productModel);
}

class UpdateProductErrorState extends ProductDetailsStates {
  final String error;

  UpdateProductErrorState(this.error);
}

class DeleteProductLoadingState extends ProductDetailsStates {}

class DeleteProductSuccessState extends ProductDetailsStates {

}

class DeleteProductErrorState extends ProductDetailsStates {
  final String error;

  DeleteProductErrorState(this.error);
}

