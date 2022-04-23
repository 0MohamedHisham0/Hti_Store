import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/cubit/states.dart';
import 'package:hti_store/models/product_model.dart';
import 'package:hti_store/modules/addtion_offcial/in_store_product/cubit/state.dart';
import 'package:hti_store/modules/addtion_offcial/out_store_product/cubit/state.dart';

import '../../../../models/list_product_model.dart';
import '../../../../modules/suppliers/all_products_screens/consumable_product/consumable_proudct_screen.dart';
import '../../../../modules/suppliers/all_products_screens/permanent_product/permanent_proudct_screen.dart';
import '../../../../shared/network/end_points.dart';
import '../../../../shared/network/local/cache_helper.dart';
import '../../../../shared/network/remote/dio_helper.dart';

class OutStoreCubit extends Cubit<OutStoreStates> {
  OutStoreCubit() : super(OutStoreInitialState());

  static OutStoreCubit get(context) => BlocProvider.of(context);

  ListProductModel? listPermanentModel;
  ListProductModel? listConsumerModel;
  String bottomMenuValue = 'المستديمة';

  ProductModel? productModelReceived;

  List<String> bottomMenuList = [
    'المستديمة',
    'المستهلكة',
  ];

  void changeBottomMenuValue(String value) {
    bottomMenuValue = value;
    emit(OutStoreChangeBottomMenuState());
    getProductsFromBottomMenuValue();
  }

  void getPermanentProducts() {
    emit(OutStoreLoadingState());

    DioHelper.getData(
      url: GET_ALL_OUT_OF_STORE,
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
                    {emit(OutStoreEmptyState())}
                  else
                    {
                      if (listPermanentModel!.status == true)
                        {
                          print("Success"),
                          emit(OutStoreSuccessState(listPermanentModel!))
                        }
                    }
                }
              else
                {
                  emit(OutStoreErrorState(
                      listPermanentModel!.message.toString()))
                }
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(OutStoreErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(OutStoreErrorState("هناك خطاء في استلام البينات"));
      }
    });
  }

  void getConsumerProducts() {
    emit(OutStoreLoadingState());

    DioHelper.getData(
      url: GET_ALL_OUT_OF_STORE,
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
                    {emit(OutStoreEmptyState())}
                  else
                    {
                      if (listConsumerModel!.status == true)
                        {
                          print("Success"),
                          emit(OutStoreSuccessState(listConsumerModel!))
                        }
                    }
                }
              else
                {
                  emit(
                      OutStoreErrorState(listConsumerModel!.message.toString()))
                }
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(OutStoreErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(OutStoreErrorState("هناك خطاء في استلام البينات"));
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
    return bottomMenuValue == 'المستديمة'
        ? listPermanentModel
        : listConsumerModel;
  }

  void changeProductState(
    bool state,
    ProductData productData,
  ) {
    emit(OutStoreChangeProductLoadingState());
    DioHelper.patchData(
      data: {
        "name": productData.name,
        "count": productData.count,
        "nameofsupplier": productData.nameofsupplier,
        "phoneofsupplier": productData.phoneofsupplier,
        "supplieredCompany": productData.supplieredCompany,
        "description": productData.description,
        "type": productData.type,
        "productId": productData.id,
        "accept": state,
      },
      url: ACCEPT_PRODUCT_TO_STORE,
      token: CacheHelper.getData(key: "token") as String,
    )
        .then((value) => {
              if (value.data != null)
                {
                  print(value.data),
                  productModelReceived = ProductModel.fromJson(value.data),
                  if (productModelReceived!.status == true)
                    {
                      emit(OutStoreChangeProductSuccessState(
                          productModelReceived!)),
                    }
                  else
                    {
                      emit(OutStoreChangeProductErrorState(
                          productModelReceived!.message.toString())),
                    }
                }
              else
                {
                  print(value.data),
                  emit(OutStoreChangeProductErrorState(
                      "حدث خطاء حاول مره اخري")),
                }
            })
        .catchError((error) {
      print(error.toString());
      emit(OutStoreChangeProductErrorState("حدث خطاء حاول مره اخري"));
    });
  }
}
