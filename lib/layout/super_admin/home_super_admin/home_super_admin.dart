import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/cubit.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/states.dart';
import 'package:hti_store/layout/super_admin/search_users_screen/search_users_screen.dart';
import 'package:hti_store/layout/super_admin/user_profile_screen/user_profile_screen.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:hti_store/shared/styles/colors.dart';

class HomeSuperAdmin extends StatelessWidget {
  const HomeSuperAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeSuperUserCubit(),
      child: BlocConsumer<HomeSuperUserCubit, HomeSuperUserStates>(
        listener: (context, state) {
          var cubit = HomeSuperUserCubit.get(context);
        },
        builder: (context, state) {
          var cubit = HomeSuperUserCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: const Text("الموظفين"),
              actions: [
                // Navigate to the Search Screen
                IconButton(
                    onPressed: () => navigateTo(context, SearchUsersScreen()),
                    icon: const Icon(Icons.search))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buttonDownMenu2(
                      initialValue: cubit.dropDownValue,
                      items: cubit.items,
                      onChanged: (value) {
                        cubit.changeDropDownMenu(value);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return userItem(
                              userName: "Ahmed Hassen ",
                              userRole: "امين مخزن",
                              userPhone: "01233244",
                              onClicked: () {
                                navigateTo(context, UserProfile());
                              });
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
