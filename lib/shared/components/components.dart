import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/models/orders_model.dart';
import 'package:hti_store/modules/orders/orders_screen/cubit/cubit.dart';
import 'package:hti_store/modules/super_admin/add_new_user/cubit/cubit.dart';
import 'package:hti_store/modules/super_admin/user_profile_screen/cubit/cubit.dart';
import 'package:hti_store/modules/suppliers/product_details_screen/product_details_screen.dart';
import 'package:hti_store/shared/components/constants.dart';
import 'package:hti_store/shared/styles/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/product_model.dart';
import '../../modules/orders/order_details/order_details_screen.dart';
import '../network/local/cache_helper.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: ElevatedButton(
        onPressed: () {
          function!();
        },
        style: ElevatedButton.styleFrom(
          primary: background,
        ),
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultTextButton({
  required Function function,
  required String text,
}) =>
    TextButton(
      onPressed: () {
        function;
      },
      child: Text(
        text.toUpperCase(),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required FormFieldValidator validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (value) {
        onSubmit!(value);
      },
      onChanged: (value) {
        onChange!(value);
      },
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget myDivider() => Container(
      width: double.infinity,
      height: 0.3,
      color: defaultColor,
    );

Future navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: widget,
        ),
      ),
    );

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: widget,
        ),
      ),
      (route) {
        return false;
      },
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget svgImage({required String path, Color? color}) {
  final Widget svgIcon = SvgPicture.asset(path, color: color);
  return svgIcon;
}

Widget userItem({
  required String userName,
  required String userRole,
  required String userPhone,
  required Function onClicked,
  required Function onDeleteClicked,
}) =>
    ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: HexColor("CFCEDF"),
          elevation: 3,
          onPrimary: defaultColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        onPressed: () {
          onClicked();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: Wrap(children: <Widget>[
            Row(
              children: [
                Container(
                  width: 65.0,
                  height: 65.0,
                  child: const Icon(
                    Icons.person,
                    color: defaultColor,
                  ),
                  decoration: BoxDecoration(
                      color: HexColor("C6C4DC"),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        translateRoleStates(fromStringToRoleStates(userRole)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        userPhone,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onDeleteClicked();
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: defaultColor,
                  ),
                  color: Colors.red,
                ),
              ],
            ),
          ]),
        ));

Widget productItem({
  required String productName,
  required String productDate,
  required String productCompany,
  required String productCount,
  required Function onDetailClicked,
  IconData icon = Icons.chair,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: HexColor("CFCEDF"),
        elevation: 3,
        onPrimary: defaultColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      onPressed: () {
        // onClicked();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9.0),
        child: Wrap(children: <Widget>[
          Row(
            children: [
              Container(
                width: 112.0,
                height: 112.0,
                child: Icon(
                  icon,
                ),
                decoration: BoxDecoration(
                    color: HexColor("C6C4DC"),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: defaultColor),
                    ),
                    Text(
                      changeDateFormat(productDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    Text(
                      "???????????? : " + productCount,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onDetailClicked();
                      },
                      child: const Text("???????????? ????????????"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ]),
      ));
}

Widget orderItem({
  required OrdersModel ordersModel,
  required int index,
  required Function onDetailClicked,
  required Function onItemClicked,
  required Function onAcceptClicked,
  required Function onRejectClicked,
  IconData icon = Icons.chair,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // <-
      color: HexColor("CFCEDF"),
// - Radius
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Wrap(children: <Widget>[
        Stack(alignment: Alignment.topLeft, children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: ordersModel
                              .data![index].acceptFromManagerStore
                              .toString() ==
                          "ACCEPTED"
                      ? Colors.green
                      : ordersModel.data![index].acceptFromManagerStore
                                  .toString() ==
                              "PENDING"
                          ? Colors.yellow
                          : Colors.red,
                  radius: 7,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(ordersModel.data![index].acceptFromManagerStore
                            .toString() ==
                        "ACCEPTED"
                    ? "??????????"
                    : ordersModel.data![index].acceptFromManagerStore
                                .toString() ==
                            "PENDING"
                        ? "?????? ????????????????"
                        : "??????????"),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ordersModel.data![index].notes!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: defaultColor),
                    ),
                    Text(
                      "?????? ?????????????? : " +
                          ordersModel.data![index].orderedProducts!.length
                              .toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    myDivider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "?????? ?????????? : " +
                          changeDateFormat(
                            ordersModel.data![index].dateOfOrder!,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    Text(
                      "?????? ???????????? : " +
                          ordersModel.data![index].whoCreatedOrder.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    ConditionalBuilder(
                        condition: ordersModel
                                .data![index].acceptFromManagerStore
                                .toString() ==
                            "ACCEPTED",
                        builder: (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "?????? ???????????? : " +
                                    changeDateFormat(
                                      ordersModel.data![index].dateOfOrder
                                          .toString(),
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                              Text(
                                "???????? ???????????? : " +
                                    ordersModel.data![index].whoAcceptOrder
                                        .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                            ],
                          );
                        },
                        fallback: (context) {
                          return Container();
                        }),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onDetailClicked();
                        },
                        child: const Text("???????????? ??????????"),
                      ),
                    ),
                    ConditionalBuilder(
                        condition: ordersModel
                                .data![index].acceptFromManagerStore
                                .toString() ==
                            "PENDING" && userRole == "STOREKEPPER",
                        builder: (context) {
                          return SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onAcceptClicked();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      elevation: 3,
                                    ),
                                    child: const Text("????????"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onRejectClicked();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      elevation: 3,
                                    ),
                                    child: const Text("??????"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        fallback: (context) {
                          return Container();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ]),
    ),
  );
}

Widget orderItemOrderData({
  required List<OrderData> ordersModel,
  required int index,
  required Function onDetailClicked,
  required Function onItemClicked,
  required Function onAcceptClicked,
  required Function onRejectClicked,
  IconData icon = Icons.chair,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // <-
      color: HexColor("CFCEDF"),
// - Radius
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Wrap(children: <Widget>[
        Stack(alignment: Alignment.topLeft, children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: ordersModel[index]
                              .acceptFromManagerStore
                              .toString() ==
                          "ACCEPTED"
                      ? Colors.green
                      : ordersModel[index].acceptFromManagerStore.toString() ==
                              "PENDING"
                          ? Colors.yellow
                          : Colors.red,
                  radius: 7,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(ordersModel[index].acceptFromManagerStore.toString() ==
                        "ACCEPTED"
                    ? "??????????"
                    : ordersModel[index].acceptFromManagerStore.toString() ==
                            "PENDING"
                        ? "?????? ????????????????"
                        : "??????????"),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ordersModel[index].notes!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: defaultColor),
                    ),
                    Text(
                      "?????? ?????????????? : " +
                          ordersModel[index].orderedProducts!.length.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    myDivider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "?????? ?????????? : " +
                          changeDateFormat(
                            ordersModel[index].dateOfOrder!,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    Text(
                      "?????? ???????????? : " +
                          ordersModel[index].whoCreatedOrder.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    ConditionalBuilder(
                        condition: ordersModel[index]
                                .acceptFromManagerStore
                                .toString() ==
                            "ACCEPTED",
                        builder: (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "?????? ???????????? : " +
                                    changeDateFormat(
                                      ordersModel[index].dateOfOrder.toString(),
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                              Text(
                                "???????? ???????????? : " +
                                    ordersModel[index]
                                        .whoAcceptOrder
                                        .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                            ],
                          );
                        },
                        fallback: (context) {
                          return Container();
                        }),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onDetailClicked();
                        },
                        child: const Text("???????????? ??????????"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ]),
    ),
  );
}

Widget productItemWithAcceptButtons({
  required String productName,
  required String productDate,
  required String productCompany,
  required String productCount,
  required String productSupplier,
  required Function onDetailClicked,
  IconData icon = Icons.chair,
  required Function onAcceptClicked,
  required Function onRejectClicked,
}) {
  return Container(
    decoration: BoxDecoration(
        color: HexColor("CFCEDF"),
        borderRadius: const BorderRadius.all(Radius.circular(10))),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 10.0),
      child: Wrap(children: <Widget>[
        Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              child: Icon(
                icon,
              ),
              decoration: BoxDecoration(
                  color: HexColor("C6C4DC"),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: defaultColor),
                  ),
                  Text(
                    changeDateFormat(productDate),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  Row(
                    children: [
                      Text(
                        productCompany,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: defaultColor),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 2,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        productSupplier,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: defaultColor),
                      ),
                    ],
                  ),
                  Text(
                    "???????????? " + productCount,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  ConditionalBuilder(
                      condition: CacheHelper.getData(key: "userRole") !=
                          "SUPERVISORYOFFICER",
                      builder: (context) {
                        return Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                onAcceptClicked();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                elevation: 3,
                              ),
                              child: const Text("????????"),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                onRejectClicked();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                elevation: 3,
                              ),
                              child: const Text("??????"),
                            ),
                          ],
                        );
                      },
                      fallback: (context) {
                        return Container();
                      })
                ],
              ),
            ),
          ],
        ),
      ]),
    ),
  );
}

Widget buttonDownMenu(
        {required List<String> items,
        required String initialValue,
        required Function onChanged}) =>
    DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButton(
          elevation: 16,
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                textDirection: TextDirection.rtl,
              ),
            );
          }).toList(),
          onChanged: (value) {
            onChanged(value);
          },
          // Initial Value
          value: initialValue,
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );

Widget buttonDownMenu2(
        {required List<String> items,
        required String initialValue,
        required Function onChanged,
        Color? color,
        double radius = 14.0}) =>
    Center(
        child: DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: const [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.yellow,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      item,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ))
            .toList(),
        value: initialValue,
        onChanged: (value) {
          onChanged(value);
        },
        icon: const Icon(
          Icons.keyboard_arrow_down,
        ),
        iconSize: 14,
        buttonHeight: 50,
        buttonWidth: double.infinity,
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: Colors.black26,
          ),
          color: color ?? HexColor("CFCEDF"),
        ),
        buttonElevation: 2,
        itemHeight: 40,
        itemPadding: EdgeInsets.only(left: 14, right: 14),
        dropdownMaxHeight: 200,
        dropdownPadding: null,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color ?? HexColor("CFCEDF"),
        ),
        dropdownElevation: 8,
        scrollbarRadius: Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
      ),
    ));

// enum
enum RoleStates {
  ADMIN,
  SUPPLIERS,
  ADDITIONOFFICIAL,
  STOREKEPPER,
  SUPERVISORYOFFICER,
  STOREMANAGER,
  SECTION,
  USER,
  DEFAULT,
}

enum ProductType {
  consumer,
  permanent,
}

String translateTypeToArabic(ProductType type) {
  switch (type) {
    case ProductType.consumer:
      return "??????????????";
    case ProductType.permanent:
      return "??????????????";
    default:
      return "";
  }
}

ProductType translateTypeToProductType(String type) {
  switch (type) {
    case "??????????????":
      return ProductType.consumer;
    case "??????????????":
      return ProductType.permanent;
    default:
      return ProductType.consumer;
  }
}

String translateTypeToEnglish(String type) {
  switch (type) {
    case "??????????????":
      return "consumer";
    case "??????????????":
      return "permanent";
    default:
      return "";
  }
}

String translateEnglishTypeToArabic(String type) {
  switch (type) {
    case "consumer":
      return "??????????????";
    case "permanent":
      return "??????????????";
    default:
      return "";
  }
}

String translateRoleStates(RoleStates state) {
  String roleInArabic;

  switch (state) {
    case RoleStates.ADMIN:
      roleInArabic = "??????????????????";
      break;
    case RoleStates.SUPPLIERS:
      roleInArabic = "????????????????";
      break;
    case RoleStates.ADDITIONOFFICIAL:
      roleInArabic = "?????????????????? ??????????????????";
      break;
    case RoleStates.STOREKEPPER:
      roleInArabic = "?????????? ??????????????";
      break;
    case RoleStates.SUPERVISORYOFFICER:
      roleInArabic = "?????????????? ??????????????";
      break;
    case RoleStates.STOREMANAGER:
      roleInArabic = "???????????? ??????????????";
      break;
    case RoleStates.SECTION:
      roleInArabic = "??????????????";
      break;
    case RoleStates.USER:
      roleInArabic = "????????????????????";
      break;
    case RoleStates.DEFAULT:
      roleInArabic = "???? ?????? ?????????? ?????????? ????";
      break;
  }
  return roleInArabic;
}

RoleStates fromStringToRoleStates(String role) {
  RoleStates roleInRoleStates;

  switch (role) {
    case "ADMIN":
      roleInRoleStates = RoleStates.ADMIN;
      break;
    case "SUPPLIERS":
      roleInRoleStates = RoleStates.SUPPLIERS;
      break;
    case "ADDITIONOFFICIAL":
      roleInRoleStates = RoleStates.ADDITIONOFFICIAL;
      break;
    case "STOREKEPPER":
      roleInRoleStates = RoleStates.STOREKEPPER;
      break;
    case "SUPERVISORYOFFICER":
      roleInRoleStates = RoleStates.SUPERVISORYOFFICER;
      break;
    case "STOREMANAGER":
      roleInRoleStates = RoleStates.STOREMANAGER;
      break;
    case "SECTION":
      roleInRoleStates = RoleStates.SECTION;
      break;
    case "USER":
      roleInRoleStates = RoleStates.USER;
      break;
    case "DEFAULT":
      roleInRoleStates = RoleStates.DEFAULT;
      break;
    default:
      roleInRoleStates = RoleStates.DEFAULT;
  }
  return roleInRoleStates;
}

String translateRoleFromArabicToEnglish(String state) {
  String roleInArabic;
  switch (state) {
    case "??????????????????":
      roleInArabic = "ADMIN";
      break;
    case "????????????????":
      roleInArabic = "SUPPLIERS";
      break;
    case "?????????????????? ??????????????????":
      roleInArabic = "ADDITIONOFFICIAL";
      break;
    case "?????????? ??????????????":
      roleInArabic = "STOREKEPPER";
      break;
    case "?????????????? ??????????????":
      roleInArabic = "SUPERVISORYOFFICER";
      break;
    case "???????????? ??????????????":
      roleInArabic = "STOREMANAGER";
      break;
    case "??????????????":
      roleInArabic = "SECTION";
      break;
    case "????????????????????":
      roleInArabic = "USER";
      break;
    case "???? ?????? ?????????? ?????????? ????":
      roleInArabic = "DEFAULT";
      break;
    default:
      roleInArabic = "";
  }
  return roleInArabic;
}

String translateRoleFromEnglishToArabic(String roleEnglish) {
  String roleInArabic;
  switch (roleEnglish) {
    case "ADMIN":
      roleInArabic = "??????????????????";
      break;
    case "SUPPLIERS":
      roleInArabic = "????????????????";
      break;
    case "ADDITIONOFFICIAL":
      roleInArabic = "?????????????????? ??????????????????";
      break;
    case "STOREKEPPER":
      roleInArabic = "?????????? ??????????????";
      break;
    case "SUPERVISORYOFFICER":
      roleInArabic = "?????????????? ??????????????";
      break;
    case "STOREMANAGER":
      roleInArabic = "???????????? ??????????????";
      break;
    case "SECTION":
      roleInArabic = "??????????????";
      break;
    case "USER":
      roleInArabic = "????????????????????";
      break;
    case "DEFAULT":
      roleInArabic = "???? ?????? ?????????? ?????????? ????";
      break;
    default:
      roleInArabic = "";
  }
  return roleInArabic;
}

List<String> getRolesInArabic() {
  List<String> roles = [
    "???????? ????????????????",
    "??????????????????",
    "????????????????",
    "?????????????????? ??????????????????",
    "?????????? ??????????????",
    "?????????????? ??????????????",
    "???????????? ??????????????",
    "??????????????",
    "????????????????????",
    "???? ?????? ?????????? ?????????? ????"
  ];
  return roles;
}

enum BranchStates { MATROH, TENTHOFRAMADAN, _6OCTOBER, DEFAULT }

String translateBranchStates(BranchStates state) {
  String branchInArabic;

  switch (state) {
    case BranchStates.MATROH:
      branchInArabic = "??????????";
      break;
    case BranchStates.TENTHOFRAMADAN:
      branchInArabic = "???????????? ???? ??????????";
      break;

    case BranchStates.DEFAULT:
      branchInArabic = "???? ?????? ?????????? ??????";
      break;
    case BranchStates._6OCTOBER:
      branchInArabic = "???????????? ???? ????????????";
      break;
  }
  return branchInArabic;
}

enum SectionStatesEnum { CS, BIS, ENG, DEFAULT }

String translateSectionStates(SectionStatesEnum state) {
  String sectionInArabic;

  switch (state) {
    case SectionStatesEnum.CS:
      sectionInArabic = "???????? ????????";
      break;
    case SectionStatesEnum.BIS:
      sectionInArabic = " ?????? ?????????? ?????????????? ?????????????????????? ?? ??????????????????";
      break;
    case SectionStatesEnum.ENG:
      sectionInArabic = "???????????? ???? ??????????";
      break;
    case SectionStatesEnum.DEFAULT:
      sectionInArabic = "???? ?????? ?????????? ??????";
      break;
  }
  return sectionInArabic;
}

Widget shimmer() => Center(
      child: SizedBox(
        width: 200.0,
        height: 200.0,
        child: Column(
          children: [
            progressLoading(),
            Shimmer.fromColors(
              baseColor: defaultColor,
              highlightColor: Colors.white,
              child: const Text(
                '?????? ???????? ?????????? ????????????????',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget progressLoading() => const SpinKitDoubleBounce(
      color: defaultColor,
    );

Widget errorWidget(String error) => Center(
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Text(
            error,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );

Widget dialog(
        {required String title,
        required String content,
        required Function onPressedDone,
        required Function onPressedCancel}) =>
    AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        MaterialButton(
          child: const Text("????????"),
          onPressed: () {

            onPressedDone();
          },
        ),
        MaterialButton(
          child: const Text("??????????"),
          onPressed: () {
            onPressedCancel();
          },
        )
      ],
    );

List<RoleStates> getRoles() {
  List<RoleStates> roles = [];
  roles.add((RoleStates.ADMIN));
  roles.add((RoleStates.SUPPLIERS));
  roles.add((RoleStates.ADDITIONOFFICIAL));
  roles.add((RoleStates.STOREKEPPER));
  roles.add((RoleStates.SUPERVISORYOFFICER));
  roles.add((RoleStates.STOREMANAGER));
  roles.add((RoleStates.SECTION));
  roles.add((RoleStates.USER));
  roles.add((RoleStates.DEFAULT));
  return roles;
}

List<BranchStates> getBranches() {
  List<BranchStates> branches = [];
  branches.add((BranchStates.MATROH));
  branches.add((BranchStates.TENTHOFRAMADAN));
  branches.add((BranchStates._6OCTOBER));
  branches.add((BranchStates.DEFAULT));
  return branches;
}

List<SectionStatesEnum> getSections() {
  List<SectionStatesEnum> sections = [];
  sections.add((SectionStatesEnum.CS));
  sections.add((SectionStatesEnum.BIS));
  sections.add((SectionStatesEnum.ENG));
  sections.add((SectionStatesEnum.DEFAULT));
  return sections;
}

Widget dialogAddRole({
  required Function onPressedDone,
  required Function onPressedCancel,
  AddUserCubit? addUserCubit,
  UserProfileCubit? userCubit,
}) {
  var cubit;

  if (addUserCubit != null) {
    cubit = addUserCubit;
  } else {
    cubit = userCubit;
  }

  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return AlertDialog(
        title: const Text(
          "?????????? ??????????",
          textAlign: TextAlign.end,
        ),
        content: Wrap(children: [
          Column(
            children: [
              const Text("???????? ?????????????? "),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: double.infinity,
                child: DropdownButton<RoleStates>(
                  isExpanded: true,
                  alignment: Alignment.center,
                  menuMaxHeight: 200,
                  value: cubit.valueRole,
                  underline: Container(
                    height: 0,
                    color: defaultColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  items: getRoles().map((RoleStates value) {
                    return DropdownMenuItem<RoleStates>(
                      alignment: Alignment.center,
                      value: value,
                      child: Text(translateRoleStates(value)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      cubit.changeRole(newValue as RoleStates);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("???????? ?????????? "),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<BranchStates>(
                  isExpanded: true,
                  alignment: Alignment.center,
                  menuMaxHeight: 200,
                  underline: Container(
                    height: 0,
                    color: defaultColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  value: cubit.valueBranch,
                  items: getBranches().map((BranchStates value) {
                    return DropdownMenuItem<BranchStates>(
                      alignment: Alignment.center,
                      value: value,
                      child: Text(translateBranchStates(value)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      cubit.changeBranch(newValue as BranchStates);
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("???????? ?????????? "),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: double.infinity,
                child: DropdownButton<SectionStatesEnum>(
                  alignment: Alignment.center,
                  menuMaxHeight: 200,
                  underline: Container(
                    height: 0,
                    color: defaultColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  value: cubit.valueSection,
                  items: getSections().map((SectionStatesEnum value) {
                    return DropdownMenuItem<SectionStatesEnum>(
                      alignment: Alignment.center,
                      value: value,
                      child: Text(translateSectionStates(value)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      cubit.changeSection(newValue as SectionStatesEnum);
                    });
                  },
                ),
              ),
            ],
          ),
        ]),
        actions: <Widget>[
          MaterialButton(
            child: const Text("??????"),
            onPressed: () {
              onPressedDone();
            },
          ),
          MaterialButton(
            child: const Text("??????????"),
            onPressed: () {
              onPressedCancel();
            },
          )
        ],
      );
    },
  );
}

Widget productsScreen(List<ProductData>? list,
    {required Function onRefresh,
    required RefreshController refreshController}) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(),
        onRefresh: () {
          onRefresh();
        },
        controller: refreshController,
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return productItem(
                  productDate: list![index].createdAt.toString(),
                  icon: list[index].type == "permanent"
                      ? Icons.chair
                      : Icons.restaurant,
                  productName: list[index].name.toString(),
                  productCompany: list[index].supplieredCompany.toString(),
                  productCount: list[index].count.toString(),
                  onDetailClicked: () {
                    navigateTo(context, ProductDetailsScreen(list[index].id!));
                  });
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },
            itemCount: list!.length),
      ),
    ),
  );
}

Widget ordersScreen(OrdersModel? orderModel,
    {required Function onRefresh,
    required RefreshController refreshController,
    required OrdersCubit cubit}) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(),
        onRefresh: () {
          onRefresh();
        },
        controller: refreshController,
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return orderItem(
                ordersModel: orderModel!,
                index: index,
                onDetailClicked: () {
                  navigateTo(context,
                      OrderDetailsScreen(orderModel.data![index].id ?? 0));
                },
                onItemClicked: () {},
                onAcceptClicked: () {
                  cubit.updateOrderState(
                      orderModel.data![index].id.toString(), "ACCEPTED");
                },
                onRejectClicked: () {
                  cubit.updateOrderState(
                      orderModel.data![index].id.toString(), "NOTFOUND");
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: orderModel!.data!.length),
      ),
    ),
  );
}

Widget ordersScreenOrderData(List<OrderData>? orderModel,
    {required Function onRefresh,
    required RefreshController refreshController,
    required UserProfileCubit cubit}) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(),
        onRefresh: () {
          onRefresh();
        },
        controller: refreshController,
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return orderItemOrderData(
                ordersModel: orderModel!,
                index: index,
                onDetailClicked: () {
                  navigateTo(
                      context, OrderDetailsScreen(orderModel[index].id ?? 0));
                },
                onItemClicked: () {},
                onAcceptClicked: () {},
                onRejectClicked: () {},
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: orderModel!.length),
      ),
    ),
  );
}

Widget productsScreenWithBottomMenuAndAcceptButtonItem(List<ProductData>? list,
    {required Function onRefresh,
    required RefreshController refreshController,
    required String dropDownValue,
    required List<String> dropDownList,
    required Function onDropDownChanged,
    required Function onAcceptClicked,
    required Function onRejectClicked}) {
  return Scaffold(
    appBar: AppBar(
      title: buttonDownMenu2(
          initialValue: dropDownValue,
          items: dropDownList,
          onChanged: (String value) {
            onDropDownChanged(value);
          }),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(),
        onRefresh: () {
          onRefresh();
        },
        controller: refreshController,
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return productItemWithAcceptButtons(
                icon: list![index].type == "permanent"
                    ? Icons.chair
                    : Icons.restaurant,
                productName: list[index].name.toString(),
                productCompany: list[index].supplieredCompany.toString(),
                productCount: list[index].count.toString(),
                onDetailClicked: () {
                  navigateTo(context, ProductDetailsScreen(list[index].id!));
                },
                onAcceptClicked: () {
                  onAcceptClicked(index);
                },
                onRejectClicked: () {
                  onRejectClicked(index);
                },
                productSupplier: list[index].nameofsupplier.toString(),
                productDate: list[index].createdAt.toString(),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },
            itemCount: list!.length),
      ),
    ),
  );
}

Widget productsScreenWithBottomMenu(List<ProductData>? list,
    {required Function onRefresh,
    required RefreshController refreshController,
    required String dropDownValue,
    required List<String> dropDownList,
    required Function onDropDownChanged}) {
  return Scaffold(
    appBar: AppBar(
      title: buttonDownMenu2(
          initialValue: dropDownValue,
          items: dropDownList,
          onChanged: (String value) {
            onDropDownChanged(value);
          }),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(),
        onRefresh: () {
          onRefresh();
        },
        controller: refreshController,
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return productItem(
                  productDate: list![index].createdAt.toString(),
                  icon: list[index].type == "permanent"
                      ? Icons.chair
                      : Icons.restaurant,
                  productName: list[index].name.toString(),
                  productCompany: list[index].supplieredCompany.toString(),
                  productCount: list[index].count.toString(),
                  onDetailClicked: () {
                    navigateTo(context, ProductDetailsScreen(list[index].id!));
                  });
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },
            itemCount: list!.length),
      ),
    ),
  );
}

Widget itemDetailRowWithDivider(
    {required String title,
    required String value,
    required context,
    double width = 20.0}) {
  return Column(
    children: <Widget>[
      const SizedBox(
        height: 10,
      ),
      myDivider(),
      const SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Container(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                  textStyle: Theme.of(context).textTheme.bodyText1!),
            ),
          ),
          SizedBox(
            width: width,
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget itemDetailRow(
    {required String title,
    required String value,
    required context,
    double width = 20.0,
    double textSize = 18.0,
    Color color = Colors.black}) {
  return Row(
    children: [
      SizedBox(
        width: 100,
        child: Text(
          title,
          style: GoogleFonts.outfit(
              textStyle: Theme.of(context).textTheme.bodyText1!,
              color: color,
              fontSize: textSize),
        ),
      ),
      SizedBox(
        width: width,
      ),
      Text(
        value,
        style: GoogleFonts.outfit(
          textStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.normal, fontSize: textSize, color: color),
        ),
      ),
    ],
  );
}

Widget defaultText(
        {required String value,
        required context,
        FontWeight? fontWeight = FontWeight.normal,
        double fontSized = 17}) =>
    Text(
      value,
      style: GoogleFonts.outfit(
        textStyle: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(fontWeight: fontWeight, fontSize: fontSized),
      ),
    );

Widget errorWidgetWithRefresh({
  required Function onClicked,
  String text = "???????? ?????????? ???????? ?????? ????????",
}) =>
    Center(
      child: Column(
        children: [
          IconButton(
              onPressed: () {
                onClicked();
              },
              icon: const Icon(Icons.refresh)),
          Text(text),
        ],
      ),
    );

enum OrderStatus {
  ACCEPTED,
  PENDING,
  NOTFOUND,
}

// translate order status to string
String orderStatusToArabic(OrderStatus status) {
  switch (status) {
    case OrderStatus.ACCEPTED:
      return "?????????????? ????????????????";
    case OrderStatus.PENDING:
      return "?????????? ?????? ????????????????";
    case OrderStatus.NOTFOUND:
      return "?????????????? ?????????? ????????????";
    default:
      return "";
  }
}

// translate string to order status
OrderStatus orderStatusFromArabic(String status) {
  switch (status) {
    case "?????????????? ????????????????":
      return OrderStatus.ACCEPTED;
    case "?????????? ?????? ????????????????":
      return OrderStatus.PENDING;
    case "?????????????? ?????????? ????????????":
      return OrderStatus.NOTFOUND;
    default:
      return OrderStatus.NOTFOUND;
  }
}

// translate string to order status
String stringOrderStateFromArabic(String status) {
  switch (status) {
    case "?????????????? ????????????????":
      return "ACCEPTED";
    case "?????????? ?????? ????????????????":
      return "PENDING";
    case "?????????????? ?????????? ????????????":
      return "NOTFOUND";
    default:
      return "NOTFOUND";
  }
}
