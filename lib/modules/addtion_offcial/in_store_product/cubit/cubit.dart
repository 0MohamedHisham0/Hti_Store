import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/cubit/states.dart';
import 'package:hti_store/modules/addtion_offcial/in_store_product/cubit/state.dart';

import '../../../../models/list_product_model.dart';
import '../../../../modules/suppliers/all_products_screens/consumable_product/consumable_proudct_screen.dart';
import '../../../../modules/suppliers/all_products_screens/permanent_product/permanent_proudct_screen.dart';
import '../../../../shared/network/end_points.dart';
import '../../../../shared/network/local/cache_helper.dart';
import '../../../../shared/network/remote/dio_helper.dart';

class InStoreCubit extends Cubit<InStoreStates> {
  InStoreCubit() : super(InStoreInitialState());

  static InStoreCubit get(context) => BlocProvider.of(context);

  ListProductModel? listPermanentModel;
  ListProductModel? listConsumerModel;
  String bottomMenuValue = 'المستديمة';

  List<String> bottomMenuList = [
    'المستديمة',
    'المستهلكة',
  ];


  void changeBottomMenuValue(String value) {
    bottomMenuValue = value;
    emit(InStoreChangeBottomMenuState());
    getProductsFromBottomMenuValue();
  }

  void getPermanentProducts() {
    emit(InStoreLoadingState());

    DioHelper.getData(
      url: GET_ALL_IN_STORE,
      query: {
        'type': 'permanent',
      },
      token: CacheHelper.getData(key: "token") as String,
    )
        .then((value) => {
              if (value.data != null)
                {
                  print(value.data),
                  listPermanentModel = ListProductModel.fromJson(value.data),
                  if (listPermanentModel!.data!.data!.isEmpty)
                    {emit(InStoreEmptyState())}
                  else
                    {
                      if (listPermanentModel!.status == true)
                        {
                          print("Success"),
                          emit(InStoreSuccessState(listPermanentModel!))
                        }
                    }
                }
              else
                {
                  emit(
                      InStoreErrorState(listPermanentModel!.message.toString()))
                }
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(InStoreErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(InStoreErrorState("هناك خطاء في استلام البينات"));
      }
    });
  }

  void getConsumerProducts() {
    emit(InStoreLoadingState());

    DioHelper.getData(
      url: GET_ALL_IN_STORE,
      query: {
        'type': 'consumer',
      },
      token: CacheHelper.getData(key: "token") as String,
    )
        .then((value) => {
              if (value.data != null)
                {
                  print(value.data),
                  listConsumerModel = ListProductModel.fromJson(value.data),
                  if (listConsumerModel!.data!.data!.isEmpty)
                    {emit(InStoreEmptyState())}
                  else
                    {
                      if (listConsumerModel!.status == true)
                        {
                          print("Success"),
                          emit(InStoreSuccessState(listConsumerModel!))
                        }
                    }
                }
              else
                {emit(InStoreErrorState(listConsumerModel!.message.toString()))}
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(InStoreErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(InStoreErrorState("هناك خطاء في استلام البينات"));
      }
    });
  }

  void getProductsFromBottomMenuValue() {
    if (bottomMenuValue == 'المستديمة') {
      getPermanentProducts();
    } else {
      getConsumerProducts();
    }
  }

  ListProductModel? getListOfProductsFromBottomMenuValue() {
    return bottomMenuValue == 'المستديمة' ? listPermanentModel : listConsumerModel;
  }
}
