
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hti_store/modules/sections/in_store_product_section/cubit/state.dart';

import '../../../../models/list_product_model.dart';

import '../../../../shared/network/end_points.dart';
import '../../../../shared/network/local/cache_helper.dart';
import '../../../../shared/network/remote/dio_helper.dart';

class InStoreSectionCubit extends Cubit<InStoreSectionStates> {
  InStoreSectionCubit() : super(InStoreSectionInitialState());

  static InStoreSectionCubit get(context) => BlocProvider.of(context);

  ListProductModel? listPermanentModel;
  ListProductModel? listConsumerModel;
  String bottomMenuValue = 'المستديمة';

  List<String> bottomMenuList = [
    'المستديمة',
    'المستهلكة',
  ];


  void changeBottomMenuValue(String value) {
    bottomMenuValue = value;
    emit(InStoreSectionChangeBottomMenuState());
    getProductsFromBottomMenuValue();
  }

  void getPermanentProducts() {
    emit(InStoreSectionLoadingState());

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
                    {emit(InStoreSectionEmptyState())}
                  else
                    {
                      if (listPermanentModel!.status == true)
                        {
                          print("Success"),
                          emit(InStoreSectionSuccessState(listPermanentModel!))
                        }
                    }
                }
              else
                {
                  emit(
                      InStoreSectionErrorState(listPermanentModel!.message.toString()))
                }
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(InStoreSectionErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(InStoreSectionErrorState("هناك خطاء في استلام البينات"));
      }
    });
  }

  void getConsumerProducts() {
    emit(InStoreSectionLoadingState());

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
                    {emit(InStoreSectionEmptyState())}
                  else
                    {
                      if (listConsumerModel!.status == true)
                        {
                          print("Success"),
                          emit(InStoreSectionSuccessState(listConsumerModel!))
                        }
                    }
                }
              else
                {emit(InStoreSectionErrorState(listConsumerModel!.message.toString()))}
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(InStoreSectionErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(InStoreSectionErrorState("هناك خطاء في استلام البينات"));
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
