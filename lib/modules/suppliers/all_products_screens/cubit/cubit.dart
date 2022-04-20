import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/list_product_model.dart';
import 'package:hti_store/modules/suppliers/all_products_screens/cubit/states.dart';

import '../../../../shared/network/end_points.dart';
import '../../../../shared/network/local/cache_helper.dart';
import '../../../../shared/network/remote/dio_helper.dart';

class AllProductsCubit extends Cubit<AllProductsStates> {
  AllProductsCubit() : super(AllProductsInitialState());

  static AllProductsCubit get(context) => BlocProvider.of(context);

  ListProductModel? listAllProductModel;
  ListProductModel? listPermanentModel;
  ListProductModel? listConsumerModel;

  void getProducts(String type) {
    emit(AllProductsLoadingState());

    DioHelper.getData(
      url: GET_ALL_OUT_OF_STORE,
      query: {
        'type': type,
      },
      token: CacheHelper.getData(key: "token") as String,
    )
        .then((value) => {
              if (value.data != null)
                {
                  print(value.data),
                  listAllProductModel = ListProductModel.fromJson(value.data),
                  if (listAllProductModel!.data!.data!.isEmpty)
                    {emit(AllProductsIsEmpty())}
                  else
                    {
                      if (listAllProductModel!.status == true)
                        {
                          print("Success"),
                          emit(AllProductsSuccessState(listAllProductModel!))
                        }
                    }
                }
              else
                {emit(AllProductsErrorState(listAllProductModel!.message.toString()))}
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(AllProductsErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(AllProductsErrorState("هناك خطاء في استلام البينات"));
      }
    });
  }

  void getPermanentProducts() {
    emit(AllProductsLoadingState());

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
                    {emit(AllProductsIsEmpty())}
                  else
                    {
                      if (listPermanentModel!.status == true)
                        {
                          print("Success"),
                          emit(AllProductsSuccessState(listPermanentModel!))
                        }
                    }
                }
              else
                {emit(AllProductsErrorState(listPermanentModel!.message.toString()))}
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(AllProductsErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(AllProductsErrorState("هناك خطاء في استلام البينات"));
      }
    });
  }

  void getConsumerProducts() {
    emit(AllProductsLoadingState());

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
                    {emit(AllProductsIsEmpty())}
                  else
                    {
                      if (listConsumerModel!.status == true)
                        {
                          print("Success"),
                          emit(AllProductsSuccessState(listConsumerModel!))
                        }
                    }
                }
              else
                {emit(AllProductsErrorState(listConsumerModel!.message.toString()))}
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(AllProductsErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(AllProductsErrorState("هناك خطاء في استلام البينات"));
      }
    });
  }
}
