import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/modules/super_admin/search_users_screen/cubit/cubit.dart';
import 'package:hti_store/modules/super_admin/search_users_screen/cubit/states.dart';

import '../../../shared/components/components.dart';
import '../user_profile_screen/user_profile_screen.dart';

class SearchUsersScreen extends StatelessWidget {
  const SearchUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? widget;
    var searchController = TextEditingController();
    return BlocProvider(
        create: (BuildContext context) => SearchCubit(),
        child:
            BlocConsumer<SearchCubit, SearchStates>(listener: (context, state) {
          var cubit = SearchCubit.get(context);
          if (state is DeleteUserSuccessState) {
            cubit.getUsers(
                translateRoleFromArabicToEnglish(cubit.dropDownValue), "", "", "", "");
          }
          if (state is DeleteUserErrorState) {
            showToast(
                text: "هناك مشكله حاول مره اخري", state: ToastStates.WARNING);
          }

          if (state is SearchErrorState) {
            widget = const Center(
              child: Text("هناك مشكله حاول مره اخري"),
            );
          }
          if (state is SearchLoadingState) {
            widget = const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SearchIsEmpty) {
            widget = Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "لا يوجد اعضاء",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ChangeDropDownMenu) {
            cubit.getUsers(translateRoleFromArabicToEnglish(state.role), "", "", "", "");
          }
        }, builder: (context, state) {
          var cubit = SearchCubit.get(context);

          return Scaffold(
            appBar: AppBar(
                // The search area here
                title: Container(
              decoration: BoxDecoration(
                color: HexColor("CFCEDF"),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(children: [
                Container(
                  decoration: BoxDecoration(
                      color: HexColor("CFCEDF"),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            cubit.getUsers("", "", "", value, "");
                          } catch (e) {}
                        }
                      },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: "بحث عن موظف",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              /* Clear the search field */
                              searchController.clear();
                            },
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ]),
            )),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ConditionalBuilder(
                      condition: state is SearchSuccessState,
                      builder: (context) {
                        return Expanded(
                          child: cubit.listUsers!.result!.data!.isEmpty
                              ? const Text("لا يوجد نتاج بحث")
                              : ListView.separated(
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
                                              UserProfile(false ,cubit.listUsers!
                                                  .result!.data![index].id!));
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
                                                    MaterialButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text("لا"),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                  itemCount:
                                      cubit.listUsers!.result!.data!.length),
                        );
                      },
                      fallback: (context) {
                        return Center(child: widget ?? const Text("اكتب اسم الموظف"));
                      }),
                ],
              ),
            ),
          );
        }));
  }
}
