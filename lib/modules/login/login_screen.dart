import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/modules/login/cubit/cubit.dart';
import 'package:hti_store/modules/login/cubit/states.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:hti_store/shared/components/constants.dart';

import '../../shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(
              key: 'token',
              value: state.loginModel.token,
            ).then((value) {
              userRole = state.loginModel.data!.roles;
              token = state.loginModel.token;
              userID = state.loginModel.data!.id;
              CacheHelper.saveData(key: "userRole", value: userRole)
                  .then((value) => {
                        CacheHelper.saveData(key: "userID", value: userID)
                            .then((value) => {
                                  navigateToHomeScreen(userRole!, context),
                                }),
                      });
            });
          }

          if (state is LoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }


        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تسجيل الدخول',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'مرحبا بك.',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'الرجاء إدخال البريد الإلكتروني';
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'الرجاء إدخال بريد إلكتروني صحيح';
                              }
                              return null;
                            },
                            label: 'البريد الإلكتروني',
                            prefix: Icons.email_outlined,
                            onChange: (value) {}),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: cubit.suffix,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              print(
                                  '${emailController.text} ====================');
                              print(passwordController.text);
                              cubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          isPassword: cubit.isPassword,
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                            print("suffixPressed");
                          },
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور قصيرة جدا';
                            }
                            return null;
                          },
                          label: 'كلمة المرور',
                          prefix: Icons.lock_outline,
                          onChange: (value) {},
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'تسجيل الدخول',
                            isUpperCase: true,
                          ),
                          fallback: (context) => progressLoading(),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'اذا كان ليس لديك حساب برجاء التوجه اللي الشؤون',
                            ),
                          ],
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
