import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/modules/orders/orders_screen/cubit/cubit.dart';
import 'package:hti_store/modules/orders/orders_screen/cubit/states.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../shared/components/components.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    Widget? widget;
    return BlocConsumer<OrdersCubit, OrdersStates>(listener: (context, state) {
      var cubit = OrdersCubit.get(context);
      if (state is OrdersErrorState) {
        _refreshController.refreshCompleted();

        widget = Center(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    cubit.getOrdersFromAPIWithBottomMenu();
                  },
                  icon: const Icon(Icons.refresh)),
              const Text("هناك مشكله حاول مره اخري"),
            ],
          ),
        );
      }
      if (state is OrdersLoadingState) {
        widget = Center(
          child: shimmer(),
        );
      }
      if (state is OrdersSuccessState) {
        _refreshController.refreshCompleted();

        widget = mainOrderScreen(cubit, _refreshController);
      }
      if (state is UpdateOrderSuccessState) {
        state.state == "ACCEPTED"
            ? showToast(text: "تم قبول الطلب بنجاح", state: ToastStates.SUCCESS)
            :state.state == "NOTFOUND" ? showToast(text: "تم رفض الطلب بنجاح", state: ToastStates.WARNING) : showToast(text: "الطلب قيد التنفيذ", state: ToastStates.WARNING);
        cubit.getOrdersFromAPIWithBottomMenu();
      }
      if (state is UpdateOrderErrorState) {
        showToast(text: state.error, state: ToastStates.ERROR);
      }
    }, builder: (context, state) {
      var cubit = OrdersCubit.get(context);
      return ConditionalBuilder(
          condition: cubit.getOrdersFromVarWithBottomMenu() != null,
          builder: (context) {
            return ConditionalBuilder(
                condition:
                    cubit.getOrdersFromVarWithBottomMenu()!.data!.isEmpty,
                builder: (context) {
                  showToast(text: "لا توجد منتجات", state: ToastStates.WARNING);
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        buttonDownMenu2(
                            initialValue: cubit.bottomMenuValue,
                            items: cubit.bottomMenuList,
                            onChanged: (String value) {
                              cubit.changeBottomMenuValue(value);
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        errorWidgetWithRefresh(
                            onClicked: () {
                              cubit.getOrdersFromAPIWithBottomMenu();
                            },
                            text: "لا يوجد منتجات"),
                      ],
                    ),
                  );
                },
                fallback: (context) {
                  return mainOrderScreen(cubit, _refreshController);
                });
          },
          fallback: (context) => widget ?? shimmer());
    });
  }

  Widget mainOrderScreen(cubit, _refreshController) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buttonDownMenu2(
                radius: 10.0,
                initialValue: cubit.bottomMenuValue,
                items: cubit.bottomMenuList,
                onChanged: (String value) {
                  cubit.changeBottomMenuValue(value);
                }),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ordersScreen(
                cubit.getOrdersFromVarWithBottomMenu(),
                onRefresh: () {
                  cubit.getOrdersFromAPIWithBottomMenu();
                },
                refreshController: _refreshController,
                cubit: cubit,
              ),
            ),
          ],
        ),
      );
}
