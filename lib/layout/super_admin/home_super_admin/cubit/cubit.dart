import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/states.dart';
import 'package:hti_store/models/delet_user_model.dart';
import 'package:hti_store/models/list_user_model.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

class HomeSuperUserCubit extends Cubit<HomeSuperUserStates> {
  HomeSuperUserCubit() : super(HomeSuperUserInitialState());

  static HomeSuperUserCubit get(context) => BlocProvider.of(context);

  // Initial Selected Value
  String dropDownValue = getRolesInArabic().first;
  ListUsers? listUsers;
  DeleteUserModel? deleteUserModel;

  // List of items in our dropdown menu
  var items = getRolesInArabic();

  void changeDropDownMenu(String value) {
    dropDownValue = value;
    emit(ChangeDropDownMenu(dropDownValue));
  }

  void getUsers(String roles, String branch, String sections, String username,
      String limit) {
    emit(HomeSuperUserLoadingState());

    DioHelper.getData(
      url: GET_ALL_USERS,
      query: {
        'roles': roles == "جميع الموظفين" ? "" : roles,
        'branch': branch,
        'sections': sections,
        'username': username,
        'limit': limit,
      },
      token: CacheHelper.getData(key: "token") as String,
    )
        .then((value) => {
              if (value.data != null)
                {
                  print(value.data),
                  print("Success"),
                  listUsers = ListUsers.fromJson(value.data),
                  if (listUsers!.result!.data!.isEmpty)
                    {emit(HomeSuperUserIsEmpty())}
                  else
                    {emit(HomeSuperUserSuccessState(listUsers!))}
                }
              else
                {emit(HomeSuperUserErrorState("هناك خطاء في استلام البينات"))}
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(HomeSuperUserErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(HomeSuperUserErrorState("هناك خطاء في استلام البينات"));
      }
    });
  }

  void deleteUser(String id) {
    emit(DeleteUserLoadingState());

    DioHelper.deleteData(
      url: DELETE_USER + "/" + id.toString(),
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      deleteUserModel = DeleteUserModel.fromJson(value.data);
      emit(DeleteUserSuccessState(deleteUserModel!));
    }).catchError((error) {
      emit(DeleteUserErrorState(error.toString()));
    });
  }
}
