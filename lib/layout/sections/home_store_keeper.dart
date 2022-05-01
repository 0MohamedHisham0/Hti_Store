
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/search_product/search_product_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeSectionScreen extends StatelessWidget {
  const HomeSectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SectionCubit(),

        child: BlocConsumer<SectionCubit, SectionStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SectionCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentScreenIndex]),
                actions: [
                  IconButton( onPressed: () => navigateTo(context, const SearchProductsScreen()),
                      icon: const Icon(Icons.search)),
                  IconButton( onPressed: () => signOut(context),
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
