import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/home_super_admin.dart';
import 'package:hti_store/modules/super_admin/user_profile_screen/cubit/states.dart';

import 'package:hti_store/shared/components/components.dart';

import 'cubit/cubit.dart';

class UserProfile extends StatelessWidget {
  const UserProfile(this.id, {Key? key}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserProfileCubit()..getUserByID(id),
      child: BlocConsumer<UserProfileCubit, UserProfileStates>(
        listener: (context, state) {
          var cubit = UserProfileCubit.get(context);

          if (state is UserProfileSuccessState) {
            print(state.UserModel.email);
          }
          if (state is UpdateUserRoleSuccessState) {
            Navigator.pop(context);

            cubit.getUserByID(id);
            showToast(
                text: "تم تحديث الصلاحيات بنجاح", state: ToastStates.SUCCESS);
          }
          if (state is UpdateUserRoleErrorState) {
            showToast(
                text: "هناك مشكله حاول مره اخري", state: ToastStates.ERROR);
          }

          if (state is UpdateUserRoleLoadingState) {
            showToast(text: "جاري تحديث الصلاحيات", state: ToastStates.WARNING);
          }
          if (state is DeleteUserSuccessState) {
            Navigator.pop(context);
            navigateAndFinish(context, HomeSuperUserScreen(text: "From User Profile",));
            showToast(text: "تم حذف الموظف بنجاح", state: ToastStates.SUCCESS);
          }
          if (state is DeleteUserLoadingState) {
            showToast(text: "جاري حذف الموظف", state: ToastStates.WARNING);
          }
          if (state is DeleteUserErrorState) {
            showToast(
                text: "هناك مشكله حاول مره اخري", state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          var cubit = UserProfileCubit.get(context);
          double width = 20.0;
          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "بيانات الموظف",
                  style: TextStyle(fontSize: 25),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => dialogAddRole(
                              onPressedDone: () {
                                cubit.updateUserRole(
                                  type: RoleStates
                                      .values[cubit.valueRole.index].name,
                                  section: SectionStates
                                      .values[cubit.valueSection.index].name,
                                  branch: BranchStates
                                      .values[cubit.valueBranch.index].name,
                                );
                              },
                              onPressedCancel: () {
                                Navigator.pop(context);
                              },
                              userCubit: cubit));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[900],
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return dialog(
                                title: "حذف موظف",
                                content:
                                    "هل انت متاكد من انك تريد حذف هذا الموظف؟",
                                onPressedDone: () {
                                  if (cubit.userData!.id != null &&
                                      cubit.userData!.id != 0) {
                                    cubit.deleteUser();
                                  }
                                },
                                onPressedCancel: () {
                                  Navigator.pop(context);
                                });
                          });
                    },
                  ),
                ],
              ),
              body: ConditionalBuilder(
                condition: state is UserProfileSuccessState,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                "اسم الموظف",
                                style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17)),
                              ),
                            ),
                            SizedBox(
                              width: width,
                            ),
                            Text(
                              "${cubit.userData!.username}",
                              style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        myDivider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                "البريد الالكتروني",
                                style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17)),
                              ),
                            ),
                            SizedBox(
                              width: width,
                            ),
                            Text(
                              "${cubit.userData!.email}",
                              style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        myDivider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                "الوظيفه",
                                style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17)),
                              ),
                            ),
                            SizedBox(
                              width: width,
                            ),
                            Text(
                              "${cubit.userData!.roles}",
                              style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        myDivider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                "القسم",
                                style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17)),
                              ),
                            ),
                            SizedBox(
                              width: width,
                            ),
                            Text(
                              "${cubit.userData!.sections}",
                              style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        myDivider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                "الفرع",
                                style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17)),
                              ),
                            ),
                            SizedBox(
                              width: width,
                            ),
                            Text(
                              "${cubit.userData!.branch}",
                              style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                fallback: (BuildContext context) {
                  return ConditionalBuilder(
                      condition: state is UserProfileErrorState,
                      builder: (context) {
                        return errorWidget("لا يوجد معلومات لهذا الموظف حاليا");
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
