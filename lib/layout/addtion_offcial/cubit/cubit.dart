import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/addtion_offcial/cubit/states.dart';
import 'package:hti_store/modules/addtion_offcial/in_store_product/in_store_product.dart';
import '../../../modules/addtion_offcial/out_store_product/out_store_product.dart';
import '../../../modules/super_admin/user_profile_screen/user_profile_screen.dart';
import '../../../shared/components/constants.dart';

class AdditionOfficialCubit extends Cubit<AdditionOfficialStates> {
  AdditionOfficialCubit() : super(AdditionOfficialInitialState());

  static AdditionOfficialCubit get(context) => BlocProvider.of(context);

  int currentScreenIndex = 0;

  List<Widget> screens = [
    const OutStoreProductScreen(),
    const InStoreProductScreen(),
    UserProfile(true , userID??0 ),

  ];

  List<String> titles = [
    'خارج المخزن',
    'داخل المخزن',
    'الملف الشخصي',

  ];

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.double_arrow_sharp),
      label: "خارج المخزن",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.store),
      label: "داخل المخزن",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "الملف الشخصي",
    ),
  ];

  void changeScreenIndex(int index) {
    currentScreenIndex = index;
    emit(ChangeScreenIndexState());
  }
}
