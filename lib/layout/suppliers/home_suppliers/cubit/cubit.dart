import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/cubit/states.dart';

import '../../../../modules/super_admin/user_profile_screen/user_profile_screen.dart';
import '../../../../modules/suppliers/all_products_screens/consumable_product/consumable_proudct_screen.dart';
import '../../../../modules/suppliers/all_products_screens/permanent_product/permanent_proudct_screen.dart';
import '../../../../shared/components/constants.dart';

class HomeSuppliersCubit extends Cubit<HomeSuppliersStates> {
  HomeSuppliersCubit() : super(HomeSuppliersInitialState());

  static HomeSuppliersCubit get(context) => BlocProvider.of(context);

  int currentScreenIndex = 0;
  List<Widget> screens = [
    const PermanentProductScreen(),
    const ConsumableProductScreen(),
    UserProfile(true , userID??0 ),

  ];

  List<String> titles = [
    'المستديمة',
    'المستهلكة',
    'الملف الشخصي',

  ];

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.chair),
      label: "المستديمة",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: "المستهلكة",
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
