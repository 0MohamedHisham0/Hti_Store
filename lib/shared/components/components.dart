import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/shared/styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: ElevatedButton(
        onPressed: () {
          function();
        },
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
      onTap: () {
        onTap!();
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
      height: 1.0,
      color: Colors.grey[300],
    );

void navigateTo(context, widget) => Navigator.push(
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
      toastLength: Toast.LENGTH_LONG,
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
}) =>
    ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: HexColor("CFCEDF"),
          onPrimary: defaultColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        onPressed: () {
          onClicked();
        },
        child: Padding(
          padding: const EdgeInsets.all(9.0),
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
                        userRole,
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
                )
              ],
            ),
          ]),
        ));

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
        required Function onChanged}) =>
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
          Icons.arrow_forward_ios_outlined,
        ),
        iconSize: 14,
        buttonHeight: 50,
        buttonWidth: double.infinity,
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black26,
          ),
          color: HexColor("CFCEDF"),
        ),
        buttonElevation: 2,
        itemHeight: 40,
        itemPadding: const EdgeInsets.only(left: 14, right: 14),
        dropdownMaxHeight: 200,
        dropdownPadding: null,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: HexColor("CFCEDF"),
        ),
        dropdownElevation: 8,
        scrollbarRadius: const Radius.circular(40),
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
  DEFAULT
}

String translateRoleStates(RoleStates state) {
  String roleInArabic;

  switch (state) {
    case RoleStates.ADMIN:
      roleInArabic = "المسؤولين";
      break;
    case RoleStates.SUPPLIERS:
      roleInArabic = "الموردين";
      break;
    case RoleStates.ADDITIONOFFICIAL:
      roleInArabic = "المسؤولين الإضافيين";
      break;
    case RoleStates.STOREKEPPER:
      roleInArabic = "امناء المخازن";
      break;
    case RoleStates.SUPERVISORYOFFICER:
      roleInArabic = "مسؤولين الرقابه";
      break;
    case RoleStates.STOREMANAGER:
      roleInArabic = "مديرين المخازن";
      break;
    case RoleStates.SECTION:
      roleInArabic = "الأقسام";
      break;
    case RoleStates.USER:
      roleInArabic = "المستخدمين";
      break;
    case RoleStates.DEFAULT:
      roleInArabic = "لم يتم تحديد وظيفه له";
      break;
  }
  return roleInArabic;
}
