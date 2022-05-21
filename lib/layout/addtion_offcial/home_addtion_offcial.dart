import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/addtion_offcial/cubit/cubit.dart';
import 'package:hti_store/layout/addtion_offcial/cubit/states.dart';
import '../../shared/components/constants.dart';

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
