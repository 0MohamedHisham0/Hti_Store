import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/modules/addtion_offcial/in_store_product/cubit/cubit.dart';
import 'package:hti_store/modules/addtion_offcial/in_store_product/cubit/state.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InStoreProductScreen extends StatelessWidget {
  const InStoreProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    Widget? widget;

    return BlocProvider(
        create: (BuildContext context) =>
            InStoreCubit()..getProductsFromBottomMenuValue(),
        child: BlocConsumer<InStoreCubit, InStoreStates>(
            listener: (context, state) {
          var cubit = InStoreCubit.get(context);
          if (state is InStoreErrorState) {
            _refreshController.refreshCompleted();

            widget = errorWidgetWithRefresh(onClicked: (context) {
              cubit.getProductsFromBottomMenuValue();
            });
          }
          if (state is InStoreLoadingState) {
            widget = Center(
              child: shimmer(),
            );
          }
          if (state is InStoreEmptyState) {
            widget = errorWidget('لا يوحد منتجات');
          }

          if (state is InStoreSuccessState) {
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
        }, builder: (context, state) {
          var cubit = InStoreCubit.get(context);
          return Scaffold(
            body: ConditionalBuilder(
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
                        return productsScreenWithBottomMenu(
                            cubit
                                .getListOfProductsFromBottomMenuValue()!
                                .data!
                                .data,
                            onRefresh: () {
                              cubit.getProductsFromBottomMenuValue();
                            },
                            refreshController: _refreshController,
                            dropDownValue: cubit.bottomMenuValue,
                            dropDownList: cubit.bottomMenuList,
                            onDropDownChanged: (value) {
                              cubit.changeBottomMenuValue(value);
                            });
                      });
                },
                fallback: (context) {
                  return widget ?? shimmer();
                }),
          );
        }));
  }
}
