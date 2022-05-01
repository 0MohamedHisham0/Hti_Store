import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/modules/addtion_offcial/in_store_product/cubit/cubit.dart';
import 'package:hti_store/modules/addtion_offcial/in_store_product/cubit/state.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../models/product_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/styles/colors.dart';
import '../../suppliers/product_details_screen/product_details_screen.dart';
import '../product_order_details_screen/product_ order_details_screen.dart';

class InStoreProductSectionScreen extends StatelessWidget {
  const InStoreProductSectionScreen({Key? key}) : super(key: key);

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
                        showToast(
                            text: "لا يوجد منتجات حاليا",
                            state: ToastStates.WARNING);
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
                              errorWidgetWithRefresh(
                                  onClicked: () {
                                    cubit.getProductsFromBottomMenuValue();
                                  },
                                  text: "لا يوجد منتجات"),
                            ],
                          ),
                        );
                      },
                      fallback: (context) {
                        return productsScreenWithBottomMenuSectionItem(
                            cubit
                                .getListOfProductsFromBottomMenuValue()!
                                .data!
                                .data,
                            context,
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

  Widget productsScreenWithBottomMenuSectionItem(
      List<ProductData>? list, context,
      {required Function onRefresh,
      required RefreshController refreshController,
      required String dropDownValue,
      required List<String> dropDownList,
      required Function onDropDownChanged}) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buttonDownMenu2(
                initialValue: dropDownValue,
                items: dropDownList,
                onChanged: (String value) {
                  onDropDownChanged(value);
                }),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                header: const WaterDropHeader(),
                onRefresh: () {
                  onRefresh();
                },
                controller: refreshController,
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: (1.36 / 2),
                  children: List.generate(list!.length, (index) {
                    return productItem(
                        productDate: list[index].createdAt.toString(),
                        icon: list[index].type == "permanent"
                            ? Icons.chair
                            : Icons.restaurant,
                        productName: list[index].name.toString(),
                        productCompany:
                            list[index].supplieredCompany.toString(),
                        productCount: list[index].count.toString(),
                        onDetailClicked: () {
                          navigateTo(
                              context, ProductOrderDetailsScreen(list[index].id!));
                        });
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productItem({
    required String productName,
    required String productDate,
    required String productCompany,
    required String productCount,
    required Function onDetailClicked,
    IconData icon = Icons.chair,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: HexColor("CFCEDF"),
        boxShadow: [
          BoxShadow(
            color: HexColor("CFCEDF"),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 155.0,
              height: 130.0,
              child: Icon(
                icon,
              ),
              decoration: BoxDecoration(
                  color: HexColor("C6C4DC"),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              productName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: defaultColor),
            ),
            Text(
              changeDateFormat(productDate),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            Text(
              "الكمية المتاحة : " + productCount,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onDetailClicked();
                },
                child: const Text("اضافة الي العربة"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
