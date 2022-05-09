import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:hti_store/shared/components/constants.dart';
import 'package:hti_store/shared/styles/colors.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SectionCartScreen extends StatelessWidget {
  const SectionCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SectionCartCubit(),
      child: BlocConsumer<SectionCartCubit, SectionCartStates>(
        listener: (context, state) {
          var cubit = SectionCartCubit.get(context);

          if (state is CreateOrderSuccessState) {
            showToast(text: "تم ارسال طلبك", state: ToastStates.SUCCESS);
            cubit.clearCart();
            controller.clear();
          }
        },
        builder: (context, state) {
          var cubit = SectionCartCubit.get(context);
          var formKey = GlobalKey<FormState>();

          return Scaffold(

              body: ConditionalBuilder(
                condition: state is! SectionCartLoadingState,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            defaultFormField(
                              controller: controller,
                              type: TextInputType.text,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'الرجاء ادخال وصف الطلب';
                                }
                                return null;
                              },
                              label: 'وصف الطلب',
                              prefix: (Icons.description),
                            ),
                            const SizedBox(
                              height: 20,
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
                                itemBuilder: (context, index) =>
                                    itemSmallProduct(
                                        cartList[index].count,
                                        cartList[index].productname,
                                        context, () {
                                      cubit.removeProduct(index);
                                    }),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemCount: cartList.length),

                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "عدد الطلبات  " + cartList.length.toString(),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ConditionalBuilder(
                              condition: state is! CreateOrderLoadingState,
                              builder: (context) => defaultButton(
                                function: () {
                                  if (cartList.isNotEmpty &&
                                      formKey.currentState!.validate()) {
                                    cubit.createOrder(
                                        controller.text, cartList);
                                  }
                                },
                                text: "طلب الآن",
                              ),
                              fallback: (context) => progressLoading(),
                            ),

                            // if Accepted
                          ],
                        ),
                      ),
                    ),
                  );
                },
                fallback: (BuildContext context) {
                  return ConditionalBuilder(
                      condition: state is SectionCartErrorState,
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

  Widget itemSmallProduct(count, name, context, Function onRemoveClicked) =>
      Container(
        decoration: BoxDecoration(
            color: HexColor("CFCEDF"), borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  itemDetailRow(
                      title: "اسم المنتج",
                      value: name,
                      context: context,
                      textSize: 14),
                  itemDetailRow(
                      title: "الكميه المطلوبه",
                      value: count.toString(),
                      context: context,
                      textSize: 14),
                ],
              ),
              // delete button
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: defaultColor,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Center(
                              child: Text("هل تريد حذف هذا المنتج")),
                          actions: [
                            MaterialButton(
                              child: Text("لا"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            MaterialButton(
                              child: Text("نعم"),
                              onPressed: () {
                                onRemoveClicked();
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                },
              )
            ],
          ),
        ),
      );
}
