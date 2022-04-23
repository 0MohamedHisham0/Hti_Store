import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/home_suppliers.dart';
import 'package:hti_store/models/product_model.dart';
import 'package:hti_store/modules/suppliers/add_new_product/cubit/cubit.dart';
import 'package:hti_store/modules/suppliers/add_new_product/cubit/states.dart';
import 'package:hti_store/modules/suppliers/product_details_screen/product_details_screen.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:numberpicker/numberpicker.dart';

import 'cubit/cubit.dart';

class UpdateProductScreen extends StatelessWidget {
  const UpdateProductScreen({Key? key, this.productModel}) : super(key: key);

  final ProductModel? productModel;

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var supplierNameController = TextEditingController();
    var supplierPhoneController = TextEditingController();
    var companyController = TextEditingController();
    var countController = TextEditingController();
    var descriptionController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    nameController.text = productModel!.data!.name.toString();
    supplierNameController.text = productModel!.data!.nameofsupplier.toString();
    supplierPhoneController.text = productModel!.data!.phoneofsupplier.toString();
    companyController.text = productModel!.data!.supplieredCompany.toString();
    countController.text = productModel!.data!.count.toString();
    descriptionController.text = productModel!.data!.description.toString();

    return BlocProvider(
      create: (context) => UpdateProductCubit(),
      child: BlocConsumer<UpdateProductCubit, UpdateProductStates>(
        listener: (context, state) {
          if (state is UpdateProductSuccessState) {
            showToast(
                text: "تعديل علي المنتج بنجاح", state: ToastStates.SUCCESS);
            Navigator.of(context).pop();
          }

          if (state is UpdateProductErrorState) {
            showToast(
                text: state.error.length > 50 ? "حدث خطاء ما" : state.error,
                state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          var cubit = UpdateProductCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('تعديل المنتج'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      defaultFormField(
                          controller: nameController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'ادخل اسم المنتج';
                            }
                            return null;
                          },
                          label: 'اسم المنتج',
                          prefix: Icons.shopping_basket),
                      const SizedBox(height: 10),
                      defaultFormField(
                          controller: supplierNameController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'ادخل اسم المورد';
                            }
                            return null;
                          },
                          label: 'اسم المورد',
                          prefix: Icons.person),
                      const SizedBox(height: 10),
                      defaultFormField(
                          controller: supplierPhoneController,
                          type: TextInputType.phone,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'ادخل رقم المورد';
                            }
                            return null;
                          },
                          label: 'رقم المورد',
                          prefix: Icons.phone),
                      const SizedBox(height: 10),
                      defaultFormField(
                          controller: companyController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'ادخل اسم الشركة';
                            }
                            return null;
                          },
                          label: 'اسم الشركة',
                          prefix: Icons.business),
                      const SizedBox(height: 10),
                      defaultFormField(
                          controller: descriptionController,
                          type: TextInputType.text,
                          validate: (value) {
                            return null;
                          },
                          label: 'الوصف (اختياري)',
                          prefix: Icons.description),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: defaultFormField(
                              controller: countController,
                              type: TextInputType.number,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'ادخل الكمية';
                                }
                                return null;
                              },
                              label: 'الكمية',
                              onChange: (value) {
                                if (int.parse(value) < 10000) {
                                  cubit.changeNumberPickedValue(
                                      int.parse(value));
                                } else {
                                  showToast(
                                      text: "اقصي كميه هي 10000",
                                      state: ToastStates.ERROR);
                                }
                              },
                              prefix: Icons.shopping_cart,
                            ),
                          ),
                          NumberPicker(
                            itemWidth: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.black26),
                            ),
                            value: cubit.numberPickedValue,
                            step: 1,
                            haptics: true,
                            axis: Axis.horizontal,
                            minValue: 0,
                            maxValue: 10000,
                            textStyle: const TextStyle(fontSize: 16),
                            onChanged: (value) {
                              cubit.changeNumberPickedValue(value.toInt());
                              countController.text = value.toString();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      buttonDownMenu2(
                          radius: 3,
                          color: Colors.white,
                          items: cubit.items,
                          initialValue: cubit.initialValue,
                          onChanged: (value) {
                            cubit.changeMenuValue(value);
                          }),
                      const SizedBox(height: 20),
                      ConditionalBuilder(
                        condition: state is! UpdateProductLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              cubit.updateProduct(
                                  productModel!.data!.id.toString(),
                                  nameController.text,
                                  cubit.numberPickedValue,
                                  supplierNameController.text,
                                  supplierPhoneController.text,
                                  companyController.text,
                                  descriptionController.text,
                                  translateTypeToEnglish(cubit.initialValue));
                            }
                          },
                          text: 'تم',
                          isUpperCase: true,
                        ),
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "تـأكد من ان جميع البينات صحيحه قبل التأكيد",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
