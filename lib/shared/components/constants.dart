import 'package:flutter/cupertino.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/home_suppliers.dart';
import 'package:hti_store/modules/login/login_screen.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:intl/intl.dart';

import '../../layout/addtion_offcial/home_addtion_offcial.dart';
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
    case 'ADDITIONOFFICIAL':
      navigateAndFinish(
        context,
        AdditionOfficialScreen(),
      );
      break;
    default:
      navigateAndFinish(
        context,
        LoginScreen(),
      );
  }
}

Widget getHomeScreen(String role) {
  switch (role) {
    case 'ADMIN':
      return HomeSuperUserScreen();
    case 'SUPPLIERS':
      return HomeSuppliersScreen();
    case 'ADDITIONOFFICIAL':
      return AdditionOfficialScreen();
    default:
      return LoginScreen();
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

String changeDateFormat(String date) {
  DateTime parseDate =
  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
  var outputDate = outputFormat.format(inputDate);

  return outputDate.contains("AM") ?  outputDate.replaceAll("AM", "ص") : outputDate.replaceAll("PM", "م");
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
