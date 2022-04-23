import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class OutStoreProductScreen extends StatelessWidget {
  const OutStoreProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    Widget? widget;
    return BlocProvider(
        create: (BuildContext context) =>
            OutStoreCubit()..getProductsFromBottomMenuValue(),
        child: BlocConsumer<OutStoreCubit, OutStoreStates>(
            listener: (context, state) {
          var cubit = OutStoreCubit.get(context);
          if (state is OutStoreErrorState) {
            _refreshController.refreshCompleted();

            widget = errorWidgetWithRefresh(onClicked: (context) {
              cubit.getProductsFromBottomMenuValue();
            });
          }
          if (state is OutStoreLoadingState) {
            widget = Center(
              child: shimmer(),
            );
          }

          if (state is OutStoreEmptyState) {
            widget = errorWidget('لا يوحد منتجات');
          }


          if (state is OutStoreSuccessState) {
            _refreshController.refreshCompleted();

            widget = productsScreenWithBottomMenu(
                cubit.getListOfProductsFromBottomMenuValue()!.data!.data,
                onRefresh: () {
                  cubit.getProductsFromBottomMenuValue();
                },
                refreshController: _refreshController,
                dropDownValue: cubit.bottomMenuValue,
                dropDownList: cubit.bottomMenuList,
                onDropDownChanged: (value) {
                  cubit.changeBottomMenuValue(value);
                });
          }

          if (state is OutStoreChangeProductSuccessState) {
            if (state.productModel.data!.accept == true) {
              showToast(text: "تم قبول المنتج", state: ToastStates.SUCCESS);
              cubit.getProductsFromBottomMenuValue();
            } else {
              showToast(text: "تم رفض المنتج", state: ToastStates.ERROR);
              cubit.getProductsFromBottomMenuValue();
            }
          }

          if (state is OutStoreChangeProductErrorState) {
            showToast(text: state.errorMessage, state: ToastStates.ERROR);
          }
        }, builder: (context, state) {
          var cubit = OutStoreCubit.get(context);
          return ConditionalBuilder(
              condition: cubit.getListOfProductsFromBottomMenuValue() != null,
              builder: (context) {
                return ConditionalBuilder(
                    condition: cubit
                        .getListOfProductsFromBottomMenuValue()!
                        .data!
                        .data!
                        .isEmpty,
                    builder: (context) {
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
                              height: 50,
                            ),
                            errorWidget('لا يوحد منتجات'),
                          ],
                        ),
                      );
                    },
                    fallback: (context) {
                      return productsScreenWithBottomMenuAndAcceptButtonItem(
                          cubit.getListOfProductsFromBottomMenuValue()!.data!.data,
                          onRefresh: () {
                            cubit.getProductsFromBottomMenuValue();
                          },
                          refreshController: _refreshController,
                          dropDownValue: cubit.bottomMenuValue,
                          dropDownList: cubit.bottomMenuList,
                          onDropDownChanged: (value) {
                            cubit.changeBottomMenuValue(value);
                          },
                          onAcceptClicked: (index) {
                            cubit.changeProductState(
                                true,
                                cubit
                                    .getListOfProductsFromBottomMenuValue()!
                                    .data!
                                    .data![index]);
                          },
                          onRejectClicked: (index) {
                            cubit.changeProductState(
                                false,
                                cubit
                                    .getListOfProductsFromBottomMenuValue()!
                                    .data!
                                    .data![index]);
                          });
                    });
              },
              fallback: (context) => widget ?? shimmer());
        }));
  }
}
