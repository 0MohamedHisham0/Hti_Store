import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/states.dart';
import 'package:hti_store/models/login_model.dart';
import 'package:hti_store/modules/super_admin/user_profile_screen/cubit/states.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

class UserProfileCubit extends Cubit<UserProfileStates> {
  UserProfileCubit() : super(UserProfileInitialState());

  static UserProfileCubit get(context) => BlocProvider.of(context);

  UserData? userData;

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
}
