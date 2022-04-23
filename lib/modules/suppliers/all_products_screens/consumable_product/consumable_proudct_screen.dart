import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../shared/components/components.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ConsumableProductScreen extends StatelessWidget {
  const ConsumableProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    Widget? widget;
    return BlocConsumer<AllProductsCubit, AllProductsStates>(
        listener: (context, state) {
      var cubit = AllProductsCubit.get(context);
      if (state is AllProductsErrorState) {
        _refreshController.refreshCompleted();

        widget = Center(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    cubit.getConsumerProducts();
                  },
                  icon: Icon(Icons.refresh)),
              const Text("هناك مشكله حاول مره اخري"),
            ],
          ),
        );
      }
      if (state is AllProductsLoadingState) {
        widget = Center(
          child: shimmer(),
        );
      }
      if (state is AllProductsSuccessState) {
        _refreshController.refreshCompleted();

        widget = productsScreen(
          cubit.listConsumerModel!.data!.data,
          onRefresh: () async {
            cubit.getConsumerProducts();
          },
          refreshController: _refreshController,
        );
      }
    }, builder: (context, state) {
      var cubit = AllProductsCubit.get(context);
      return ConditionalBuilder(
          condition: cubit.listConsumerModel != null,
          builder: (context) {
            return productsScreen(cubit.listConsumerModel!.data!.data,
              onRefresh: () {
                cubit.getConsumerProducts();
              },
              refreshController: _refreshController,
            );
          },
          fallback: (context) => widget ?? shimmer());
    });
  }
}
