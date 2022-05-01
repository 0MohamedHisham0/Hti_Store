import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/modules/super_admin/add_new_user/cubit/states.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';

import '../../../../models/login_model.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/network/remote/dio_helper.dart';

class AddUserCubit extends Cubit<AddUserStates> {
  AddUserCubit() : super(AddUserInitialState());

  static AddUserCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  var valueRole = getRoles()[0];
  var valueBranch = getBranches()[0];
  var valueSection = getSections()[0];

  late LoginModel AddUserModel;

  void userAddUser({
    @required String? email,
    @required String? password,
    @required String? name,
  }) {
    emit(AddUserLoadingState());

    DioHelper.postData(
      url: CREATE_USER,
      data: {"username": name, "password": password, "email": email},
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      print(value.data);
      AddUserModel = LoginModel.fromJson(value.data);

      if (AddUserModel.status == true) {
        emit(AddUserSuccessState(AddUserModel));
      } else {
        emit(AddUserErrorState(AddUserModel.message!));
      }

    }).catchError((error) {
      print(error.toString());
      emit(AddUserErrorState(error.toString()));
    });
  }

  void updateUserRole({
    required String? type,
    required String? section,
    required String? branch,
  }) {
    emit(UpdateUserRoleLoadingState());

    DioHelper.patchData(
      url: UPDATE_ROLE + "/" + AddUserModel.data!.id.toString(),
      data: {"type": type, "section": section, "branch": branch},
      token: CacheHelper.getData(key: "token"),
    ).then((value) {

      AddUserModel = LoginModel.fromJson(value.data);
      emit(UpdateUserRoleSuccessState(AddUserModel));

    }).catchError((error) {
      emit(UpdateUserRoleErrorState(error.toString()));
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());
  }

  void changeRole(RoleStates value) {
    valueRole = value;
    emit(ChangeRoleState());
    print(valueRole.name + "changed");
  }

  void changeBranch(BranchStates value) {
    valueBranch = value;
    emit(ChangeBranchState());
  }

  void changeSection(SectionStatesEnum value) {
    valueSection = value;
    emit(ChangeSectionState());
  }
}
