import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/modules/suppliers/all_products_screens/cubit/cubit.dart';
import 'package:hti_store/modules/suppliers/all_products_screens/cubit/states.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../shared/components/components.dart';

class PermanentProductScreen extends StatelessWidget {
  const PermanentProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController = RefreshController(initialRefresh: false);
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
                    cubit.getPermanentProducts();
                  },
                  icon: const Icon(Icons.refresh)),
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
          cubit.listPermanentModel!.data!.data,
          onRefresh: ()  {
            cubit.getPermanentProducts();
          },
          refreshController: _refreshController,
        );
      }

    }, builder: (context, state) {
      var cubit = AllProductsCubit.get(context);
      return ConditionalBuilder(
          condition: cubit.listPermanentModel != null,
          builder: (context) {
            return productsScreen(
              cubit.listPermanentModel!.data!.data,
              onRefresh: ()  {
                cubit.getPermanentProducts();
              },
              refreshController: _refreshController,
            );
          },
          fallback: (context) => widget ?? shimmer());
    });
  }
}
