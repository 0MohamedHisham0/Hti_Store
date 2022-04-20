import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/cubit/states.dart';

import '../../../../modules/suppliers/all_products_screens/consumable_product/consumable_proudct_screen.dart';
import '../../../../modules/suppliers/all_products_screens/permanent_product/permanent_proudct_screen.dart';

class HomeSuppliersCubit extends Cubit<HomeSuppliersStates> {
  HomeSuppliersCubit() : super(HomeSuppliersInitialState());

  static HomeSuppliersCubit get(context) => BlocProvider.of(context);

  int currentScreenIndex = 0;
  List<Widget> screens = [
    const PermanentProductScreen(),
    const ConsumableProductScreen(),
  ];

  List<String> titles = [
    'المستديمة',
    'المستهلكة',
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
  ];

  void changeScreenIndex(int index) {
    currentScreenIndex = index;
    emit(ChangeScreenIndexState());
  }
}
