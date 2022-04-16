import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/cubit.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/states.dart';
import 'package:hti_store/modules/super_admin/add_new_user/add_new_user.dart';
import 'package:hti_store/shared/components/components.dart';
import '../../../modules/super_admin/search_users_screen/search_users_screen.dart';
import '../../../modules/super_admin/user_profile_screen/user_profile_screen.dart';

class HomeSuperUserScreen extends StatelessWidget {
  const HomeSuperUserScreen({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    Widget? widget;

    return BlocProvider(
      create: (BuildContext context) =>
          HomeSuperUserCubit()..getUsers("جميع الموظفين", "", "", "", ""),
      child: BlocConsumer<HomeSuperUserCubit, HomeSuperUserStates>(
        listener: (context, state) {
          var cubit = HomeSuperUserCubit.get(context);
          if (state is DeleteUserSuccessState) {
            cubit.getUsers(
                reTranslateRoleState(cubit.dropDownValue), "", "", "", "");
          }
          if (state is DeleteUserErrorState) {
            showToast(
                text: "هناك مشكله حاول مره اخري", state: ToastStates.WARNING);
          }

          if (state is HomeSuperUserErrorState) {
            widget = const Center(
              child: Text("هناك مشكله حاول مره اخري"),
            );
          }
          if (state is HomeSuperUserIsEmpty) {
            widget = Padding(
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
                  const Center(
                    child: Text("لا يوجد اعضاء"),
                  ),
                ],
              ),
            );
          }

          if (state is ChangeDropDownMenu) {
            print(state.role);
            print(reTranslateRoleState(state.role));
            cubit.getUsers(reTranslateRoleState(state.role), "", "", "", "");
          }
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
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () => navigateTo(context, AddNewUserScreen()),
                  child: const Icon(Icons.person_add),
                ),
              ),
              body: ConditionalBuilder(
                condition: state is HomeSuperUserSuccessState,
                builder: (BuildContext context) {
                  return Padding(
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
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return userItem(
                                    userName: cubit.listUsers!.result!
                                        .data![index].username!,
                                    userRole: cubit
                                        .listUsers!.result!.data![index].roles!,
                                    userPhone: cubit
                                        .listUsers!.result!.data![index].email!,
                                    onClicked: () {
                                      navigateTo(
                                          context,
                                          UserProfile(cubit.listUsers!.result!
                                              .data![index].id!));
                                    },
                                    onDeleteClicked: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("تأكيد"),
                                              content: const Text(
                                                  "هل تريد حذف هذا الموظف؟"),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("لا"),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    cubit.deleteUser(cubit
                                                        .listUsers!
                                                        .result!
                                                        .data![index]
                                                        .id!
                                                        .toString());
                                                  },
                                                  child: const Text("نعم"),
                                                )
                                              ],
                                            );
                                          });
                                    });
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 12,
                                );
                              },
                              itemCount: cubit.listUsers!.result!.data!.length),
                        ),
                      ],
                    ),
                  );
                },
                fallback: (BuildContext context) {
                  return ConditionalBuilder(
                    condition: state is HomeSuperUserLoadingState,
                    builder: (context) {
                      return shimmer();
                    },
                    fallback: (context) {
                      return widget ??
                          Padding(
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
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return userItem(
                                            userName: cubit.listUsers!.result!
                                                .data![index].username!,
                                            userRole: cubit.listUsers!.result!
                                                .data![index].roles!,
                                            userPhone: cubit.listUsers!.result!
                                                .data![index].email!,
                                            onClicked: () {
                                              navigateTo(
                                                  context,
                                                  UserProfile(cubit
                                                      .listUsers!
                                                      .result!
                                                      .data![index]
                                                      .id!));
                                            },
                                            onDeleteClicked: () {
                                              cubit.deleteUser(cubit.listUsers!
                                                  .result!.data![index].id!
                                                  .toString());
                                            });
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 12,
                                        );
                                      },
                                      itemCount: cubit
                                          .listUsers!.result!.data!.length),
                                ),
                              ],
                            ),
                          );
                    },
                  );
                },
              ));
        },
      ),
    );
  }
}
