import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/login_model.dart';
import 'package:hti_store/modules/login/cubit/states.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';

import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  late LoginModel loginModel;

  void userLogin({
    required String? email,
    required String? password,
  }) {
    emit(LoginLoadingState());

    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);

      if (loginModel.status == true) {
        print("true");
        emit(LoginSuccessState(loginModel));
      } else {
        print("false");

        print(loginModel.message);
        emit(LoginErrorState(loginModel.message.toString()));
      }

      if (loginModel.status == false) {
        print("false");

        emit(LoginErrorState(loginModel.message.toString()));
      }

      if (value.statusCode == 400) {
        print("400");

        emit(LoginErrorState(loginModel.message.toString()));
      }

    }).catchError((error) {
      print(error);
      emit(LoginErrorState("خطأ بالبريد الاليكتروني او كلمه المرور"));
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());
  }
}
