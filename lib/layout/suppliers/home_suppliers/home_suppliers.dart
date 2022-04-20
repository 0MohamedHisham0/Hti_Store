import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/cubit/cubit.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/cubit/states.dart';
import 'package:hti_store/modules/suppliers/add_new_product/add_new_product_screen.dart';

import '../../../modules/super_admin/search_users_screen/search_users_screen.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class HomeSuppliersScreen extends StatelessWidget {
  const HomeSuppliersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeSuppliersCubit(),
        child: BlocConsumer<HomeSuppliersCubit, HomeSuppliersStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = HomeSuppliersCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                title: const Text('المنتجات خارج المخزن'),
                actions: [
                  IconButton(
                      onPressed: () => navigateTo(context, SearchUsersScreen()),
                      icon: const Icon(Icons.search)),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => navigateTo(context, AddNewProductScreen()),
                child: const Icon(Icons.add),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: cubit.bottomItems,
                currentIndex: cubit.currentScreenIndex,
                onTap: (index) {
                  cubit.changeScreenIndex(index);
                },
              ),
              body: cubit.screens[cubit.currentScreenIndex],

            );
          },
        ));
  }
}
