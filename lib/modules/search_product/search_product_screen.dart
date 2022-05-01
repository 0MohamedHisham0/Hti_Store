import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/modules/search_product/cubit/cubit.dart';
import 'package:hti_store/modules/search_product/cubit/states.dart';
import 'package:hti_store/modules/suppliers/product_details_screen/product_details_screen.dart';
import '../../../shared/components/components.dart';

class SearchProductsScreen extends StatelessWidget {
  const SearchProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? widget;
    var searchController = TextEditingController();
    return BlocProvider(
        create: (BuildContext context) => SearchProductCubit(),
        child: BlocConsumer<SearchProductCubit, SearchProductStates>(
            listener: (context, state) {
          var cubit = SearchProductCubit.get(context);

          if (state is SearchErrorState) {
            widget = const Center(
              child: Text("هناك مشكله حاول مره اخري"),
            );
          }
          if (state is SearchLoadingState) {
            widget =  const LinearProgressIndicator(
              color: Colors.white,
            );
          }
          if (state is SearchIsEmpty) {
            widget = Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "لا يوجد منتجات",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
        }, builder: (context, state) {
          var cubit = SearchProductCubit.get(context);

          return Scaffold(
            appBar: AppBar(
                // The search area here
                title: Container(
              decoration: BoxDecoration(
                color: HexColor("CFCEDF"),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(children: [
                Container(
                  decoration: BoxDecoration(
                      color: HexColor("CFCEDF"),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            cubit.searchProduct(value);
                          } catch (e) {}
                        }
                      },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: "بحث عن منتج",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              /* Clear the search field */
                              searchController.clear();
                            },
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ]),
            )),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ConditionalBuilder(
                      condition: state is SearchSuccessState,
                      builder: (context) {
                        return Expanded(
                          child: cubit.listProductModel!.data!.data!.isEmpty
                              ? const Text("لا يوجد نتاج بحث")
                              : ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return productItem(
                                      productName: cubit.listProductModel!.data!
                                          .data![index].name
                                          .toString(),
                                      productDate: cubit
                                          .listProductModel!
                                          .data!
                                          .data![index]
                                          .createdAt
                                          .toString(),
                                      productCompany: cubit.listProductModel!
                                          .data!.data![index].supplieredCompany
                                          .toString(),
                                      productCount: cubit.listProductModel!
                                          .data!.data![index].count
                                          .toString(),
                                      onDetailClicked: () {
                                        navigateTo(
                                            context,
                                            ProductDetailsScreen(cubit
                                                .listProductModel!
                                                .data!
                                                .data![index]
                                                .id!));
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 12,
                                    );
                                  },
                                  itemCount:
                                      cubit.listProductModel!.data!.data!.length),
                        );
                      },
                      fallback: (context) {
                        return Center(
                            child: widget ?? const Text("اكتب اسم المنتج"));
                      }),
                ],
              ),
            ),
          );
        }));
  }

}
