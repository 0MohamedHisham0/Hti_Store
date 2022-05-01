import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/create_order_model.dart';
import 'package:hti_store/models/orders_model.dart';
import 'package:hti_store/modules/orders/section_cart/cubit/states.dart';
import 'package:hti_store/shared/components/constants.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

import '../../../../shared/components/components.dart';
import '../../../sections/product_order_details_screen/cubit/states.dart';

class SectionCartCubit extends Cubit<SectionCartStates> {
  SectionCartCubit() : super(SectionCartInitialState());

  static SectionCartCubit get(context) => BlocProvider.of(context);
  OrderData? orderData;

  void removeProduct(int index) {
    cartList.removeAt(index);
    emit(SectionCartRemoveProductState());
  }

  void createOrder(String notes, List<OrderedProductsCreated> list) {
    emit(CreateOrderLoadingState());
    CreateOrderModel createOrderModel = CreateOrderModel(
      notes: notes,
      orderedProducts: list,
    );
    DioHelper.postData(
            data: createOrderModel.toJson(), url: CREATE_ORDER, token: token)
        .then((value) {
      orderData = OrderData.fromJson(value.data);
      if (value.data['status'] == true) {
        emit(CreateOrderSuccessState(orderData!));
      } else {
        emit(CreateOrderErrorState(value.data['message']));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CreateOrderErrorState("هناك مشكله في استلام البينات"));
    });
  }

  void clearCart() {
    cartList.clear();
    emit(SectionCartClearCartState());
  }
}
