import 'package:flutter/cupertino.dart';
import 'package:hti_store/layout/sections/home_store_keeper.dart';
import 'package:hti_store/layout/store_keeper/home_store_keeper.dart';
import 'package:hti_store/layout/suppliers/home_suppliers/home_suppliers.dart';
import 'package:hti_store/modules/login/login_screen.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:intl/intl.dart';

import '../../layout/addtion_offcial/home_addtion_offcial.dart';
import '../../layout/super_admin/home_super_admin/home_super_admin.dart';
import '../../models/create_order_model.dart';
import '../../models/orders_model.dart';
import 'components.dart';

void navigateToHomeScreen(String role, BuildContext context) {
  switch (role) {
    case 'ADMIN':
      navigateAndFinish(
        context,
        const HomeSuperUserScreen(),
      );
      break;
    case 'SUPPLIERS':
      navigateAndFinish(
        context,
        const HomeSuppliersScreen(),
      );
      break;
    case 'ADDITIONOFFICIAL':
      navigateAndFinish(
        context,
        const AdditionOfficialScreen(),
      );
      break;
    case 'SUPERVISORYOFFICER':
      navigateAndFinish(
        context,
        const AdditionOfficialScreen(),
      );
      break;
    case 'STOREKEPPER':
      navigateAndFinish(
        context,
        const HomeStoreKeeperScreen(),
      );
      break;
    case 'SECTION':
      navigateAndFinish(
        context,
        const HomeSectionScreen(),
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
      return const HomeSuperUserScreen();
    case 'SUPPLIERS':
      return const HomeSuppliersScreen();
    case 'ADDITIONOFFICIAL':
      return const AdditionOfficialScreen();
    case 'SUPERVISORYOFFICER':
      return const AdditionOfficialScreen();
    case 'STOREKEPPER':
      return const HomeStoreKeeperScreen();
    case 'STOREMANAGER':
      return const HomeStoreKeeperScreen();
    case 'SECTION':
      return const HomeSectionScreen();
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
  DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
  var outputDate = outputFormat.format(inputDate);

  return outputDate.contains("AM")
      ? outputDate.replaceAll("AM", "ص")
      : outputDate.replaceAll("PM", "م");
}

// get corona data api
String getCoronaDataApi() {
  return "https://corona.lmao.ninja/v2/all";
}

String? userRole;
String? token;
int? userID;

List<OrderedProductsCreated> cartList = [];



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
