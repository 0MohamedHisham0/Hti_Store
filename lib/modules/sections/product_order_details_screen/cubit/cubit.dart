import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/delet_user_model.dart';
import 'package:hti_store/models/login_model.dart';
import 'package:hti_store/models/product_model.dart';
import 'package:hti_store/modules/sections/product_order_details_screen/cubit/states.dart';
import 'package:hti_store/modules/suppliers/product_details_screen/cubit/states.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

import '../../../../models/orders_model.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/components/constants.dart';

class ProductOrderDetailsCubit extends Cubit<ProductOrderDetailsStates> {
  ProductOrderDetailsCubit() : super(ProductOrderDetailsInitialState());

  static ProductOrderDetailsCubit get(context) => BlocProvider.of(context);

  ProductModel? productModel;

  int orderCount = 0;

  void getProductByID(int id) {
    emit(ProductOrderDetailsLoadingState());

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
            {
              getProductCurrentCountInCart(),
              emit(ProductOrderDetailsSuccessState(productModel!))
            }
          else
            {
              emit(ProductOrderDetailsErrorState(
                  productModel!.message.toString()))
            }
        }
      else
        {
          emit(ProductOrderDetailsErrorState(
              "هناك مشكله في استلام البينات")),
        }
    })
        .catchError((error) {
      print(error.toString());
      emit(ProductOrderDetailsErrorState("هناك مشكله في استلام البينات"));
    });
  }



  void changeOrderCount(int value) {
    orderCount = value;
    emit(ChangeOrderCountState(orderCount));
  }

  void getProductCurrentCountInCart() {
    cartList.forEach((element) {
      if (int.parse(element.id) == productModel!.data!.id) {
        print("element.id: ${element.id}");
        orderCount = int.parse(element.count);
        emit(ChangeOrderCountState(orderCount));
      }
    });
  }
}
