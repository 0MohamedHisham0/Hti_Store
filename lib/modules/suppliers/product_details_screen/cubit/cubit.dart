import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/delet_user_model.dart';
import 'package:hti_store/models/login_model.dart';
import 'package:hti_store/models/product_model.dart';
import 'package:hti_store/modules/suppliers/product_details_screen/cubit/states.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

import '../../../../shared/components/components.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  ProductDetailsCubit() : super(ProductDetailsInitialState());

  static ProductDetailsCubit get(context) => BlocProvider.of(context);

  ProductModel? productModel;

  void getProductByID(int id) {
    emit(ProductDetailsLoadingState());

    DioHelper.getData(
      url: GET_PRODUCT_BY_ID + "/$id",
      token: CacheHelper.getData(key: "token"),
      query: {},
    )
        .then((value) =>
    {
      if (value.statusCode == 200)
        {
          print(value.data),
          productModel = ProductModel.fromJson(value.data),
          if (productModel!.status == true)
            {emit(ProductDetailsSuccessState(productModel!))}
          else
            {
              emit(ProductDetailsErrorState(
                  productModel!.message.toString()))
            }
        }
      else
        {
          emit(
              ProductDetailsErrorState("هناك مشكله في استلام البينات")),
        }
    })
        .catchError((error) {
      print(error.toString());
      emit(ProductDetailsErrorState("هناك مشكله في استلام البينات"));
    });
  }

  void deleteProduct() {
    emit(DeleteProductLoadingState());

    DioHelper.deleteData(
      url: DELTE_PRODUCT_BY_ID + "/" + productModel!.data!.id.toString(),
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      emit(DeleteProductSuccessState());
    }).catchError((error) {
      emit(DeleteProductErrorState(error.toString()));
    });
  }

  void updateProduct(String name,
      int count,
      String nameofsupplier,
      String phoneofsupplier,
      String supplieredCompany,
      String description,
      String type) {
    emit(DeleteProductLoadingState());

    DioHelper.patchData(
      url: DELTE_PRODUCT_BY_ID + "/" + productModel!.data!.id.toString(),
      token: CacheHelper.getData(key: "token"),
      data: {
        "name": name,
        "count": count,
        "nameofsupplier": nameofsupplier,
        "phoneofsupplier": phoneofsupplier,
        "supplieredCompany": supplieredCompany,
        "description": description,
        "type": type,
      },
    ).then((value) {
      if (value.statusCode == 200) {
        print(value.data);

        productModel = ProductModel.fromJson(value.data);
        if (productModel!.status == true) {
          emit(UpdateProductSuccessState(productModel!));
        }
        else {
          emit(UpdateProductErrorState(productModel!.message.toString()));
        }
      }
      else {
        emit(UpdateProductErrorState("هناك مشكله في استلام البينات"));
      }
    }).catchError((error) {
      print(error.toString());
      emit(UpdateProductErrorState("هناك مشكله في استلام البينات"));
    });
  }
}
