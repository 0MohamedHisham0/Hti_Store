import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:counter/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/orders_model.dart';
import 'package:hti_store/shared/components/components.dart';

import '../../../models/create_order_model.dart';
import '../../../shared/components/constants.dart';
import '../../suppliers/update_product/update_product.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ProductOrderDetailsScreen extends StatelessWidget {
  const ProductOrderDetailsScreen(this.id, {Key? key}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    var countController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) =>
          ProductOrderDetailsCubit()..getProductByID(id),
      child: BlocConsumer<ProductOrderDetailsCubit, ProductOrderDetailsStates>(
        listener: (context, state) {
          var cubit = ProductOrderDetailsCubit.get(context);

          if (state is ProductOrderDetailsSuccessState) {
            print(state.productOrderModel.status);
          }
        },
        builder: (context, state) {
          var cubit = ProductOrderDetailsCubit.get(context);
          late OrderedProductsCreated orderedProducts;

          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "تفاصيل المنتج",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              body: ConditionalBuilder(
                condition: state is! ProductOrderDetailsLoadingState,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        itemDetailRow(
                            title: "اسم المنتج",
                            value: "${cubit.productModel!.data!.name}",
                            context: context),
                        itemDetailRowWithDivider(
                            title: "الكمية المتاحة",
                            value: "${cubit.productModel!.data!.count}",
                            context: context),
                        itemDetailRowWithDivider(
                            title: "اسم المورد",
                            value:
                                "${cubit.productModel!.data!.nameofsupplier}",
                            context: context),
                        itemDetailRowWithDivider(
                            title: "رقم المورد",
                            value:
                                "${cubit.productModel!.data!.phoneofsupplier}",
                            context: context),
                        itemDetailRowWithDivider(
                            title: "اسم الشركه",
                            value:
                                "${cubit.productModel!.data!.supplieredCompany}",
                            context: context),
                        itemDetailRowWithDivider(
                            title: "النوع",
                            value: translateEnglishTypeToArabic(
                                cubit.productModel!.data!.type.toString()),
                            context: context),
                        itemDetailRowWithDivider(
                            title: "وصف المنتج",
                            value: "${cubit.productModel!.data!.description}",
                            context: context),
                        ConditionalBuilder(
                            condition: cubit.productModel!.data!.count != 0,
                            builder: (context) {
                              //counter circle button plus and minus
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  myDivider(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text("الكميه المطلوبه",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (cubit.orderCount <
                                              cubit
                                                  .productModel!.data!.count!) {
                                            cubit.changeOrderCount(
                                                cubit.orderCount + 1);
                                          } else {
                                            showToast(
                                                text:
                                                    "لا يمكنك طلب كميه اكثر من المتاحة",
                                                state: ToastStates.WARNING);
                                          }
                                        },
                                        child: const Icon(Icons.add,
                                            color: Colors.white),
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          padding: const EdgeInsets.all(20),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                        child: Text("${cubit.orderCount}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 40,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (cubit.orderCount > 0) {
                                            cubit.changeOrderCount(
                                                cubit.orderCount - 1);
                                          }
                                        },
                                        child: const Icon(Icons.minimize,
                                            color: Colors.white),
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          padding: const EdgeInsets.all(20),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  defaultButton(
                                      function: () {
                                        if (cubit.orderCount > 0) {
                                          orderedProducts =
                                              OrderedProductsCreated(
                                            productname:
                                                cubit.productModel!.data!.name!,
                                            id: cubit.productModel!.data!.id
                                                .toString(),
                                            count: cubit.orderCount.toString(),
                                          );
                                          bool isExist = false;
                                          cartList.forEach((element) {
                                            if (element.id ==
                                                orderedProducts.id) {
                                              isExist = true;
                                            }
                                          });

                                          if (!isExist) {
                                            cartList.add(orderedProducts);
                                            showToast(
                                                text: "تم الاضافة الى السلة",
                                                state: ToastStates.SUCCESS);
                                          } else {
                                            cartList.forEach((element) {
                                              if (element.id == orderedProducts.id) {
                                                element.count = orderedProducts.count;
                                                showToast(text: "تم اضافه كميه جديده الي السلة", state: ToastStates.SUCCESS);
                                              }

                                            });
                                          }
                                        }
                                      },
                                      text: "اضافه الي العربة")
                                ],
                              );
                            },
                            fallback: (context) {
                              return Column(
                                children: const [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("لا يوجد كميه من هذا المنتج حاليا"),
                                ],
                              );
                            }),
                      ],
                    ),
                  );
                },
                fallback: (BuildContext context) {
                  return ConditionalBuilder(
                      condition: state is ProductOrderDetailsErrorState,
                      builder: (context) {
                        return Center(
                            child: errorWidget(
                                "لا يوجد معلومات لهذا المنتج حاليا"));
                      },
                      fallback: (context) {
                        return shimmer();
                      });
                },
              ));
        },
      ),
    );
  }
}
