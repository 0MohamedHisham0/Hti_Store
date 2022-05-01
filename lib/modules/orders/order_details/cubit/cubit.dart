import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/delet_user_model.dart';
import 'package:hti_store/models/login_model.dart';
import 'package:hti_store/models/orders_model.dart';
import 'package:hti_store/modules/orders/order_details/cubit/states.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

import '../../../../shared/components/components.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsStates> {
  OrderDetailsCubit() : super(OrderDetailsInitialState());

  static OrderDetailsCubit get(context) => BlocProvider.of(context);

  OrderData? orderModel;

  void getOrderByID(int id) {
    emit(OrderDetailsLoadingState());

    DioHelper.getData(
      url: GET_ORDER_BY_ID + "/$id",
      token: CacheHelper.getData(key: "token"),
      query: {},
    )
        .then((value) => {
              if (value.statusCode == 200)
                {
                  print(value.data),
                  orderModel = OrderData.fromJson(value.data["data"]),
                  if (value.data['status'] == true)
                    {emit(OrderDetailsSuccessState(orderModel!))}
                  else
                    {
                      emit(OrderDetailsErrorState(
                          value.data['message'].toString()))
                    }
                }
              else
                {
                  emit(OrderDetailsErrorState("هناك مشكله في استلام البينات")),
                }
            })
        .catchError((error) {
      print(error.toString());
      emit(OrderDetailsErrorState("هناك مشكله في استلام البينات"));
    });
  }
}
