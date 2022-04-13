import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/modules/login/cubit/cubit.dart';
import 'package:hti_store/modules/login/cubit/states.dart';
import 'package:hti_store/shared/components/components.dart';

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
            //             // if (state.loginModel.status) {
            //             //   print(state.loginModel.message);
            //             //   print(state.loginModel.data.token);
            //             //
            //             //   CacheHelper.saveData(
            //             //     key: 'token',
            //             //     value: state.loginModel.data.token,
            //             //   ).then((value) {
            //             //     navigateAndFinish(
            //             //       context,
            //             //       Layout(),
            //             //     );
            //             //   });
            //             // } else {
            //             //   print(state.loginModel.message);
            //             //
            //             //   showToast(
            //             //     text: state.loginModel.message,
            //             //     state: ToastStates.ERROR,
            //             //   );
            //             // }
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
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'من فضلك ادخل البريد الإلكتروني';
                              }
                            },
                            label:
                                'البريد الإلكتروني او رقم الهاتف الموظف او الجهه',
                            prefix: Icons.email_outlined,
                            onChange: (value) {}),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: LoginCubit.get(context).suffix,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              // cubit.userLogin(
                              //   email: emailController.text,
                              //   password: passwordController.text,
                              // );
                            }
                          },
                          isPassword: cubit.isPassword,
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                            print("suffixPressed");
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'الرقم السري قصير جدا';
                            }
                          },
                          label: 'الرقم السري',
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
                                // cubit.userLogin(
                                //   email: emailController.text,
                                //   password: passwordController.text,
                                // );
                              }
                            },
                            text: 'تسجيل الدخول',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
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
