import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/list_product_model.dart';
import 'package:hti_store/models/orders_model.dart';
import 'package:hti_store/modules/orders/orders_screen/cubit/states.dart';
import 'package:hti_store/modules/suppliers/all_products_screens/cubit/states.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:hti_store/shared/components/constants.dart';

import '../../../../shared/network/end_points.dart';
import '../../../../shared/network/local/cache_helper.dart';
import '../../../../shared/network/remote/dio_helper.dart';

class OrdersCubit extends Cubit<OrdersStates> {
  OrdersCubit() : super(OrdersInitialState());

  static OrdersCubit get(context) => BlocProvider.of(context);

  OrdersModel? acceptedOrderModel;
  OrdersModel? pendingOrderModel;
  OrdersModel? notFoundOrderModel;

  String bottomMenuValue = 'تم التأكيد';

  List<String> bottomMenuList = [
    "تم التأكيد",
    "قيد الانتظار",
    "لم يتم العثور علي الطلب",
  ];

  void changeBottomMenuValue(String value) {
    bottomMenuValue = value;
    emit(InStoreChangeBottomMenuState());
    getOrdersFromAPIWithBottomMenu();
  }

  void getAcceptedOrders(String type) {
    emit(OrdersLoadingState());

    DioHelper.getData(
      url: GET_ORDERS,
      query: {
        'orderstatus': type,
      },
      token: CacheHelper.getData(key: "token"),
    )
        .then((value) => {
              if (value.data != null)
                {
                  print(value.data),
                  acceptedOrderModel = OrdersModel.fromJson(value.data),
                  if (acceptedOrderModel!.data!.isEmpty)
                    {emit(OrdersIsEmpty())}
                  else
                    {
                      print("Success"),
                      emit(OrdersSuccessState(acceptedOrderModel!))
                    }
                }
              else
                {emit(OrdersErrorState(acceptedOrderModel!.message.toString()))}
            })
        .catchError((error) {
      print(error.toString());
      emit(OrdersErrorState("هناك خطاء في استلام البينات"));
    });
  }

  void getPendingOrders(String type) {
    emit(OrdersLoadingState());

    DioHelper.getData(
      url: GET_ORDERS,
      query: {
        'orderstatus': type,
      },
      token: CacheHelper.getData(key: "token"),
    )
        .then((value) => {
              if (value.data != null)
                {
                  print(value.data),
                  pendingOrderModel = OrdersModel.fromJson(value.data),
                  if (pendingOrderModel!.data!.isEmpty)
                    {emit(OrdersIsEmpty())}
                  else
                    {
                      if (pendingOrderModel!.status == true)
                        {
                          print("Success"),
                          emit(OrdersSuccessState(pendingOrderModel!))
                        }
                    }
                }
              else
                {emit(OrdersErrorState(pendingOrderModel!.message.toString()))}
            })
        .catchError((error) {
      print(error.toString());
      emit(OrdersErrorState("هناك خطاء في استلام البينات"));
    });
  }

  void getNotFoundOrders(String type) {
    emit(OrdersLoadingState());

    DioHelper.getData(
      url: GET_ORDERS,
      query: {
        'orderstatus': type,
      },
      token: CacheHelper.getData(key: "token"),
    )
        .then((value) => {
              if (value.data != null)
                {
                  print(value.data),
                  notFoundOrderModel = OrdersModel.fromJson(value.data),
                  if (notFoundOrderModel!.data!.isEmpty)
                    {emit(OrdersIsEmpty())}
                  else
                    {
                      if (notFoundOrderModel!.status == true)
                        {
                          print("Success"),
                          emit(OrdersSuccessState(notFoundOrderModel!))
                        }
                    }
                }
              else
                {emit(OrdersErrorState(notFoundOrderModel!.message.toString()))}
            })
        .catchError((error) {
      print(error.toString());
      emit(OrdersErrorState("هناك خطاء في استلام البينات"));
    });
  }

  void updateOrderState(String id, String status) {
    DioHelper.patchData(
      data: {"acceptFromManagerStore": status},
      url: UPDATE_OREDER_STATE + "/$id",
      token: CacheHelper.getData(key: "token"),
    )
        .then((value) => {
              print(value.data),
              if (value.data['status'] == true)
                {emit(UpdateOrderSuccessState(value.data['data']['acceptFromManagerStore']))}
              else
                {emit(UpdateOrderErrorState(value.data['message']))}
            })
        .catchError((error) {
      emit(UpdateOrderErrorState("هناك خطاء حاول مره اخري"));
      print(error.toString());
    });
  }

  void getOrdersFromAPIWithBottomMenu() {
    print(bottomMenuValue);
    print(stringOrderStateFromArabic(bottomMenuValue));

    switch (stringOrderStateFromArabic(bottomMenuValue)) {
      case "ACCEPTED":
        getAcceptedOrders("ACCEPTED");
        break;
      case "PENDING":
        getPendingOrders("PENDING");
        break;
      case "NOTFOUND":
        getNotFoundOrders("NOTFOUND");
        break;
      default:
    }
  }

  OrdersModel? getOrdersFromVarWithBottomMenu() {
    switch (stringOrderStateFromArabic(bottomMenuValue)) {
      case "ACCEPTED":
        return acceptedOrderModel;
      case "PENDING":
        return pendingOrderModel;
      case "NOTFOUND":
        return notFoundOrderModel;
      default:
        return null;
    }
  }
}
