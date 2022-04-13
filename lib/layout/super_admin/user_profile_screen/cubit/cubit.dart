import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/states.dart';
import 'package:hti_store/layout/super_admin/user_profile_screen/cubit/states.dart';
import 'package:hti_store/models/login_model.dart';

class UserProfileCubit extends Cubit<UserProfileStates> {
  UserProfileCubit() : super(UserProfileInitialState());

  static UserProfileCubit get(context) => BlocProvider.of(context);


}
