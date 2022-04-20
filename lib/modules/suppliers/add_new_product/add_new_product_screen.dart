import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/home_suppliers.dart';
import 'package:hti_store/modules/suppliers/add_new_product/cubit/cubit.dart';
import 'package:hti_store/modules/suppliers/add_new_product/cubit/states.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:numberpicker/numberpicker.dart';

class AddNewProductScreen extends StatelessWidget {
  const AddNewProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var supplierNameController = TextEditingController();
    var supplierPhoneController = TextEditingController();
    var companyController = TextEditingController();
    var countController = TextEditingController();
    var descriptionController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => AddNewProductCubit(),
      child: BlocConsumer<AddNewProductCubit, AddNewProductStates>(
        listener: (context, state) {

          if (state is AddNewProductSuccessState) {
            showToast(
                text: "تم اضافه المنتج بنجاح", state: ToastStates.SUCCESS);
            navigateAndFinish(context, HomeSuppliersScreen());
          }

          if (state is AddNewProductErrorState) {
            showToast(
                text: state.error.length > 50 ? "حدث خطاء ما" : state.error,
                state: ToastStates.ERROR);
          }

        },
        builder: (context, state) {
          var cubit = AddNewProductCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('اضافة منتج جديد'),
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
                        condition: state is! AddNewProductLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              cubit.addNewProduct(
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
