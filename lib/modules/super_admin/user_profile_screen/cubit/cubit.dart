import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/delet_user_model.dart';
import 'package:hti_store/models/login_model.dart';
import 'package:hti_store/modules/super_admin/user_profile_screen/cubit/states.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

import '../../../../shared/components/components.dart';

class UserProfileCubit extends Cubit<UserProfileStates> {
  UserProfileCubit() : super(UserProfileInitialState());

  static UserProfileCubit get(context) => BlocProvider.of(context);

  UserData? userData;
  DeleteUserModel? deleteUserModel;

  var valueRole = getRoles()[0];
  var valueBranch = getBranches()[0];
  var valueSection = getSections()[0];

  void getUserByID(int id) {
    emit(UserProfileLoadingState());

    DioHelper.getData(
      url: GET_USER_BY_ID + "/$id",
      token: CacheHelper.getData(key: "token"),
      query: {},
    )
        .then((value) => {
              if (value.statusCode == 200)
                {
                  print(value.data),
                  userData = UserData.fromJson(value.data),
                  emit(UserProfileSuccessState(userData!))
                }
              else
                {
                  emit(UserProfileErrorState("هناك مشكله في استلام البينات")),
                }
            })
        .catchError((error) {
      print(error.toString());
      emit(UserProfileErrorState(error.toString()));
    });
  }

  void updateUserRole({
    required String? type,
    required String? section,
    required String? branch,
  }) {
    emit(UpdateUserRoleLoadingState());

    DioHelper.patchData(
      url: UPDATE_ROLE + "/" + userData!.id.toString(),
      data: {"type": type, "section": section, "branch": branch},
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      userData = UserData.fromJson(value.data);
      emit(UpdateUserRoleSuccessState(userData!));
    }).catchError((error) {
      emit(UpdateUserRoleErrorState(error.toString()));
    });
  }

  void deleteUser() {
    emit(DeleteUserLoadingState());

    DioHelper.deleteData(
      url: DELETE_USER + "/" + userData!.id.toString(),
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      deleteUserModel = DeleteUserModel.fromJson(value.data);
      emit(DeleteUserSuccessState(deleteUserModel!));
    }).catchError((error) {
      emit(DeleteUserErrorState(error.toString()));
    });
  }

}
