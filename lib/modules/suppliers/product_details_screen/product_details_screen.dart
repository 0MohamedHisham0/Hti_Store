import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/home_super_admin.dart';
import 'package:hti_store/modules/super_admin/user_profile_screen/cubit/states.dart';

import 'package:hti_store/shared/components/components.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen(this.id, {Key? key}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ProductDetailsCubit()..getProductByID(id),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
        listener: (context, state) {
          var cubit = ProductDetailsCubit.get(context);

          if (state is ProductDetailsSuccessState) {
            print(state.productModel.status);
          }
        },
        builder: (context, state) {
          var cubit = ProductDetailsCubit.get(context);
          double width = 20.0;
          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "تفاصيل المنتج",
                  style: TextStyle(fontSize: 25),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[900],
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              body: ConditionalBuilder(
                condition: state is ProductDetailsSuccessState,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [

                        itemDetailRow(title: "اسم المنتج", value:  "${cubit.productModel!.data!.name}", context: context),
                        itemDetailRowWithDivider(title: "الكمية", value:  "${cubit.productModel!.data!.count}", context: context),
                        itemDetailRowWithDivider(title: "اسم المورد", value:  "${cubit.productModel!.data!.nameofsupplier}", context: context),
                        itemDetailRowWithDivider(title: "رقم المورد", value:  "${cubit.productModel!.data!.phoneofsupplier}", context: context),
                        itemDetailRowWithDivider(title: "اسم الشركه", value:  "${cubit.productModel!.data!.supplieredCompany}", context: context),
                        itemDetailRowWithDivider(title: "النوع", value:  translateEnglishTypeToArabic(cubit.productModel!.data!.type.toString()), context: context),
                        itemDetailRowWithDivider(title: "وصف المنتج", value:  "${cubit.productModel!.data!.description}", context: context),

                      ],
                    ),
                  );
                },
                fallback: (BuildContext context) {
                  return ConditionalBuilder(
                      condition: state is ProductDetailsErrorState,
                      builder: (context) {
                        return errorWidget("لا يوجد معلومات لهذا المنتج حاليا");
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
