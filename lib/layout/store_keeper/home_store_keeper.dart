import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/store_keeper/cubit/cubit.dart';
import 'package:hti_store/layout/store_keeper/cubit/states.dart';
import 'package:hti_store/modules/search_product/search_product_screen.dart';
import 'package:hti_store/shared/components/components.dart';
import '../../shared/components/constants.dart';

class HomeStoreKeeper extends StatelessWidget {
  const HomeStoreKeeper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (context) => StoreKeeperCubit(),
        child: BlocConsumer<StoreKeeperCubit, StoreKeeperStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = StoreKeeperCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentScreenIndex]),
                actions: [
                  IconButton(
                      onPressed: () => signOut(context),
                      icon: const Icon(Icons.logout)),
                  IconButton(
                      onPressed: () => navigateTo(context, const SearchProductsScreen()),
                      icon: const Icon(Icons.search)),
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
