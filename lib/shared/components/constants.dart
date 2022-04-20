import 'package:flutter/cupertino.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/home_suppliers.dart';
import 'package:hti_store/modules/login/login_screen.dart';
import 'package:hti_store/modules/on_boarding/on_boarding_screen.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';

import '../../layout/super_admin/home_super_admin/home_super_admin.dart';
import 'components.dart';

void navigateToHomeScreen(String role, BuildContext context) {
  switch (role) {
    case 'ADMIN':
      navigateAndFinish(
        context,
        HomeSuperUserScreen(),
      );
      break;
    case 'SUPPLIERS':
      navigateAndFinish(
        context,
        HomeSuppliersScreen(),
      );
      break;
    default:
      navigateAndFinish(
        context,
        OnBoardingScreen(),
      );
  }
}

Widget getHomeScreen(String role) {
  switch (role) {
    case 'ADMIN':
      return HomeSuperUserScreen();
    case 'SUPPLIERS':
      return HomeSuppliersScreen();
    default:
      return OnBoardingScreen();
  }
}

void signOut(BuildContext context) {
  CacheHelper.removeData(key: "userRole").then((value) => {
        CacheHelper.removeData(key: "token"),
        navigateAndFinish(
          context,
          LoginScreen(),
        ),
        showToast(text: "تم تسجيل الخروج بنجاح", state: ToastStates.SUCCESS)
      });
}

// enum RoleStates {
//   ADMIN,
//   SUPPLIERS,
//   ADDITIONOFFICIAL,
//   STOREKEPPER,
//   SUPERVISORYOFFICER,
//   STOREMANAGER,
//   SECTION,
//   USER,
//   DEFAULT,
// }
