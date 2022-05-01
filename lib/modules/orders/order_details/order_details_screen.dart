import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:hti_store/shared/components/constants.dart';
import 'package:hti_store/shared/styles/colors.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen(this.id, {Key? key}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OrderDetailsCubit()..getOrderByID(id),
      child: BlocConsumer<OrderDetailsCubit, OrderDetailsStates>(
        listener: (context, state) {
          var cubit = OrderDetailsCubit.get(context);

          if (state is OrderDetailsSuccessState) {
            print(state.orderModel.id);
          }
        },
        builder: (context, state) {
          var cubit = OrderDetailsCubit.get(context);

          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "تفاصيل الطلب",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              body: ConditionalBuilder(
                condition: state is OrderDetailsSuccessState,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          itemDetailRow(
                              title: "تفصيل الطلب",
                              value: "${cubit.orderModel!.notes}",
                              context: context),
                          itemDetailRowWithDivider(
                              title: " اسم الطالب",
                              value: "${cubit.orderModel!.whoCreatedOrder}",
                              context: context),
                          itemDetailRowWithDivider(
                              title: "القسم",
                              value: "${cubit.orderModel!.branch}",
                              context: context),
                          itemDetailRowWithDivider(
                              title: "تارخ الطلب",
                              value: changeDateFormat(
                                  cubit.orderModel!.dateOfOrder.toString()),
                              context: context),

                          ConditionalBuilder(
                              condition: cubit
                                      .orderModel!.acceptFromManagerStore
                                      .toString() ==
                                  "ACCEPTED",
                              builder: (context) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    itemDetailRowWithDivider(
                                        title: "تاريخ التسليم",
                                        value: changeDateFormat(cubit
                                            .orderModel!.dateOfsent
                                            .toString()),
                                        context: context),
                                    itemDetailRowWithDivider(
                                        title: "امين المخازن",
                                        value:
                                            "${cubit.orderModel!.whoAcceptOrder}",
                                        context: context),
                                  ],
                                );
                              },
                              fallback: (context) {
                                return Container();
                              }),
                          const SizedBox(
                            height: 8,
                          ),
                          myDivider(),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "الطلبات",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => itemSmallProduct(
                                  cubit.orderModel!.orderedProducts![index]
                                      .count,
                                  cubit.orderModel!.orderedProducts![index]
                                      .productname,
                                  context),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemCount:
                                  cubit.orderModel!.orderedProducts!.length),

                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "عدد الطلبات  " +
                                  cubit.orderModel!.orderedProducts!.length
                                      .toString(),
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),

                          // if Accepted
                        ],
                      ),
                    ),
                  );
                },
                fallback: (BuildContext context) {
                  return ConditionalBuilder(
                      condition: state is OrderDetailsErrorState,
                      builder: (context) {
                        return Center(
                            child: errorWidget(
                                "لا يوجد معلومات لهذا الطلب حاليا"));
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

  Widget itemSmallProduct(count, name, context) => Container(
        decoration: BoxDecoration(
            color: defaultColor, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              itemDetailRow(
                  title: "اسم المنتج",
                  value: name,
                  context: context,
                  color: Colors.white,
                  textSize: 14),
              itemDetailRow(
                  title: "الكميه المطلوبه",
                  value: count.toString(),
                  context: context,
                  color: Colors.white,
                  textSize: 14),
            ],
          ),
        ),
      );
}
