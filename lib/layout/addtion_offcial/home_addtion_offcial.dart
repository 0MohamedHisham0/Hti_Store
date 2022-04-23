import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/layout/addtion_offcial/cubit/cubit.dart';
import 'package:hti_store/layout/addtion_offcial/cubit/states.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/cubit/cubit.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/cubit/states.dart';
import 'package:hti_store/modules/suppliers/add_new_product/add_new_product_screen.dart';

import '../../modules/super_admin/search_users_screen/search_users_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/colors.dart';

class AdditionOfficialScreen extends StatelessWidget {
  const AdditionOfficialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AdditionOfficialCubit(),
        child: BlocConsumer<AdditionOfficialCubit, AdditionOfficialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AdditionOfficialCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentScreenIndex]),
                actions: [
                  IconButton(
                      onPressed: () => signOut(context),
                      icon: const Icon(Icons.logout)),
                ],
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
