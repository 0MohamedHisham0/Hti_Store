import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/sections/cubit/states.dart';
import 'package:hti_store/modules/orders/orders_screen/orders_screen.dart';
import 'package:hti_store/modules/super_admin/user_profile_screen/user_profile_screen.dart';
import '../../../modules/sections/in_store_product_section/in_store_product.dart';
import '../../../shared/components/constants.dart';

class SectionCubit extends Cubit<SectionStates> {
  SectionCubit() : super(SectionInitialState());

  static SectionCubit get(context) => BlocProvider.of(context);

  int currentScreenIndex = 0;

  List<Widget> screens = [
    const InStoreProductSectionScreen(),
    const OrderScreen(),
    UserProfile(true, userID ?? 0),
  ];

  List<String> titles = [
    'المخزن',
    'الطلبات',
    'الملف الشخصي',
  ];

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.store),
      label: "المخزن",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: "الطلبات",
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
