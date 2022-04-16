import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/home_super_admin.dart';
import 'package:hti_store/modules/super_admin/add_new_user/cubit/cubit.dart';
import 'package:hti_store/modules/super_admin/add_new_user/cubit/states.dart';
import 'package:hti_store/shared/components/components.dart';

class AddNewUserScreen extends StatelessWidget {
  AddNewUserScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();

  var userNameController = TextEditingController();
  var userEmailController = TextEditingController();
  var userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddUserCubit(),
      child: BlocConsumer<AddUserCubit, AddUserStates>(
        listener: (context, state) {
          if (state is AddUserSuccessState) {
            var cubit = AddUserCubit.get(context);

            showToast(text: state.addUserModel.message!, state: ToastStates.SUCCESS);

            if (state.addUserModel.status == true) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => dialog(
                      title: "لقد تمت العملية بنجاح",
                      content: "هل تريد اضافه وظيفه لهذا الموظف الان ؟",
                      onPressedDone: () {
                        showToast(
                            text: state.addUserModel.message!,
                            state: ToastStates.SUCCESS);
                        Navigator.pop(context, true);
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
                                addUserCubit: cubit,));
                      },
                      onPressedCancel: () {
                        Navigator.pop(context, true);

                        showToast(
                            text: state.addUserModel.message!,
                            state: ToastStates.ERROR);
                      }));
            }
          }
          if (state is AddUserErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is UpdateUserRoleSuccessState) {
            Navigator.pop(context);
            navigateAndFinish(context, const HomeSuperUserScreen());
            showToast(
                text: "تم تعديل بيانات الموظف", state: ToastStates.SUCCESS);
          }

          if (state is UpdateUserRoleErrorState) {
            Navigator.pop(context);
            navigateAndFinish(context, const HomeSuperUserScreen());
            showToast(
                text: "هناك مشكله حاول مره اخري لاحقا",
                state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          var cubit = AddUserCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: const Text('اضافة مستخدم جديد'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        defaultFormField(
                            controller: userNameController,
                            type: TextInputType.text,
                            validate: (value) {
                              if (userNameController.text.isEmpty) {
                                return 'من فضلك ادخل اسم الموظف';
                              }
                              return null;
                            },
                            label: "اسم الموظف",
                            prefix: Icons.person),
                        const SizedBox(height: 16),
                        defaultFormField(
                            controller: userEmailController,
                            type: TextInputType.emailAddress,
                            validate: (value) {
                              if (userEmailController.text.isEmpty) {
                                return 'من فضلك ادخل البريد الالكتروني';
                              }
                              return null;
                            },
                            label: "البريد الالكتروني",
                            prefix: Icons.email),
                        const SizedBox(height: 16),
                        defaultFormField(
                          controller: userPasswordController,
                          type: TextInputType.visiblePassword,
                          suffix: cubit.suffix,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {}
                          },
                          isPassword: cubit.isPassword,
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                          },
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            return null;
                          },
                          label: 'كلمة المرور',
                          prefix: Icons.lock_outline,
                          onChange: (value) {},
                        ),
                        const SizedBox(height: 25),
                        ConditionalBuilder(
                          condition: state is! AddUserLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userAddUser(
                                  email: userEmailController.text,
                                  password: userPasswordController.text,
                                  name: userNameController.text,
                                );
                              }
                            },
                            text: 'إضافة',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
