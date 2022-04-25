import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/store_keeper/cubit/states.dart';
import 'package:hti_store/modules/addtion_offcial/in_store_product/in_store_product.dart';
import 'package:hti_store/modules/super_admin/user_profile_screen/user_profile_screen.dart';
import '../../../modules/addtion_offcial/out_store_product/out_store_product.dart';
import '../../../shared/components/constants.dart';

class StoreKeeperCubit extends Cubit<StoreKeeperStates> {
  StoreKeeperCubit() : super(StoreKeeperInitialState());

  static StoreKeeperCubit get(context) => BlocProvider.of(context);

  int currentScreenIndex = 0;

  List<Widget> screens = [
    const InStoreProductScreen(),
    const OutStoreProductScreen(),
    UserProfile(true , userID??0 ),
  ];

  List<String> titles = [
    'المخزن',
    'خارج المخزن',
    'الملف الشخصي',
  ];

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.store),
      label: "المخزن",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.double_arrow_sharp),
      label: "خارج المخزن",
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
