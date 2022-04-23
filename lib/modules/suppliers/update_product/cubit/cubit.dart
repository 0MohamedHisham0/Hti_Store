import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/states.dart';
import 'package:hti_store/models/delet_user_model.dart';
import 'package:hti_store/models/list_user_model.dart';
import 'package:hti_store/modules/suppliers/add_new_product/cubit/states.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

import '../../../../models/product_model.dart';

class UpdateProductCubit extends Cubit<UpdateProductStates> {
  UpdateProductCubit() : super(UpdateProductInitialState());

  static UpdateProductCubit get(context) => BlocProvider.of(context);


  List<String> items = [
    'مستديمة',
    'مستهلكة',
  ];
  var numberPickedValue = 0;
  var initialValue = "مستديمة";
  ProductModel? productModel;

  void changeNumberPickedValue(int value) {
    emit(UpdateProductChangeNumberPickedState());
    numberPickedValue = value;
  }

  void changeMenuValue(String value) {
    emit(UpdateProductChangeMenuState());
    initialValue = value;
  }

  void updateProduct(
      String id,
      String name,
      int count,
      String nameofsupplier,
      String phoneofsupplier,
      String supplieredCompany,
      String description,
      String type) {
    emit(UpdateProductLoadingState());

    DioHelper.patchData(
            data: {
          "name": name,
          "count": count,
          "nameofsupplier": nameofsupplier,
          "phoneofsupplier": phoneofsupplier,
          "supplieredCompany": supplieredCompany,
          "description": description,
          "type": type,
        },
            url: UPDATE_PRODUCT_BY_ID + "/$id",
            token: CacheHelper.getData(key: "token"))
        .then((value) => {
              if (value.statusCode == 201 || value.statusCode == 200)
                {
                  productModel = ProductModel.fromJson(value.data),
                  if (productModel!.status == true)
                    emit(UpdateProductSuccessState(productModel!))
                  else
                    {
                      emit(UpdateProductErrorState(
                          productModel!.message.toString()))
                    }
                }
              else
                {print(value.data), emit(UpdateProductErrorState(value.data))}
            })
        .catchError((error) {
              print(error);
              emit(UpdateProductErrorState(error.toString()));
            });
  }
}
