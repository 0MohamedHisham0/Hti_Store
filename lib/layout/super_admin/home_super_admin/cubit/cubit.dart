import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/states.dart';
import 'package:hti_store/models/list_user_model.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

class HomeSuperUserCubit extends Cubit<HomeSuperUserStates> {
  HomeSuperUserCubit() : super(HomeSuperUserInitialState());

  static HomeSuperUserCubit get(context) => BlocProvider.of(context);

  // Initial Selected Value
  String dropDownValue = 'جميع الموظفين';
  ListUsers? listUsers;

  // List of items in our dropdown menu
  var items = [
    'جميع الموظفين',
    'امناء المخازن',
    'مديرين المخازن',
    'مسؤولين الاضافه',
    'مسؤولين الرقابه',
    'الجهات و الاقسام',
  ];

  void changeDropDownMenu(String value) {
    dropDownValue = value;
    emit(ChangeDropDownMenu());
  }

  void getUsers(String roles, String branch, String sections, String username,
      String limit) {
    emit(HomeSuperUserLoadingState());

    DioHelper.getData(url: GET_ALL_USERS, query: {
      roles: 'roles',
      branch: 'branch',
      sections: 'sections',
      username: 'username',
      limit: 'limit'
    },token: CacheHelper.getData(key: "token") ,)
        .then((value) => {
              if (value.data != null)
                {
                  print("Success"),
                  listUsers = ListUsers.fromJson(value.data),
                  emit(HomeSuperUserSuccessState(listUsers!))
                }
              else
                {emit(HomeSuperUserErrorState("هناك خطاء في استلام البينات"))}
            })
        .catchError((error) {
      print(error.toString());
      emit(HomeSuperUserErrorState(error.toString()));
    });
  }
}
