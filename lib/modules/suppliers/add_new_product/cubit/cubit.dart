import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

import '../../../../models/product_model.dart';
import '../../update_product/cubit/states.dart';

class AddNewProductCubit extends Cubit<AddNewProductStates> {
  AddNewProductCubit() : super(AddNewProductInitialState());

  static AddNewProductCubit get(context) => BlocProvider.of(context);

  List<String> items = [
    'مستديمة',
    'مستهلكة',
  ];
  var numberPickedValue = 0;
  var initialValue = "مستديمة";
  ProductModel? productModel;

  void changeNumberPickedValue(int value) {
    emit(AddNewProductChangeNumberPickedState());
    numberPickedValue = value;
  }

  void changeMenuValue(String value) {
    emit(AddNewProductChangeMenuState());
    initialValue = value;
  }

  void addNewProduct(
      String name,
      int count,
      String nameofsupplier,
      String phoneofsupplier,
      String supplieredCompany,
      String description,
      String type) {
    emit(AddNewProductLoadingState());

    DioHelper.postData(data: {
      "name": name,
      "count": count,
      "nameofsupplier": nameofsupplier,
      "phoneofsupplier": phoneofsupplier,
      "supplieredCompany": supplieredCompany,
      "description": description,
      "type": type,
    }, url: ADD_PRODUCT, token: CacheHelper.getData(key: "token"))
        .then((value) => {
              if (value.statusCode == 201 || value.statusCode == 200)
                {
                  productModel = ProductModel.fromJson(value.data),
                  if (productModel!.status == true)
                    emit(AddNewProductSuccessState(productModel!))
                  else
                    {
                      emit(AddNewProductErrorState(
                          productModel!.message.toString()))
                    }
                }
              else
                {print(value.data), emit(AddNewProductErrorState(value.data))}
            })
        .catchError((error) => {
              print(error),
              emit(AddNewProductErrorState(error.toString())),
            });
  }
}
