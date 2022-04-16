import 'package:bloc/bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hti_store/modules/super_admin/add_new_user/cubit/cubit.dart';
import 'package:hti_store/modules/super_admin/user_profile_screen/cubit/cubit.dart';
import 'package:hti_store/shared/styles/colors.dart';
import 'package:shimmer/shimmer.dart';

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
          Icons.keyboard_arrow_down,
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
  DEFAULT,
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

String reTranslateRoleState(String state) {
  String roleInArabic;
  switch (state) {
    case "المسؤولين":
      roleInArabic = "ADMIN";
      break;
    case "الموردين":
      roleInArabic = "SUPPLIERS";
      break;
    case "المسؤولين الإضافيين":
      roleInArabic = "ADDITIONOFFICIAL";
      break;
    case "امناء المخازن":
      roleInArabic = "STOREKEPPER";
      break;
    case "مسؤولين الرقابه":
      roleInArabic = "SUPERVISORYOFFICER";
      break;
    case "مديرين المخازن":
      roleInArabic = "STOREMANAGER";
      break;
    case "الأقسام":
      roleInArabic = "SECTION";
      break;
    case "المستخدمين":
      roleInArabic = "USER";
      break;
    case "لم يتم تحديد وظيفه له":
      roleInArabic = "DEFAULT";
      break;
    default:
      roleInArabic = "";
  }
  return roleInArabic;
}

List<String> getRolesInArabic() {
  List<String> roles = [
    "جميع الموظفين",
    "المسؤولين",
    "الموردين",
    "المسؤولين الإضافيين",
    "امناء المخازن",
    "مسؤولين الرقابه",
    "مديرين المخازن",
    "الأقسام",
    "المستخدمين",
    "لم يتم تحديد وظيفه له"
  ];
  return roles;
}

enum BranchStates { MATROH, TENTHOFRAMADAN, _6OCTOBER, DEFAULT }

String translateBranchStates(BranchStates state) {
  String branchInArabic;

  switch (state) {
    case BranchStates.MATROH:
      branchInArabic = "مطروح";
      break;
    case BranchStates.TENTHOFRAMADAN:
      branchInArabic = "العاشر من رمضان";
      break;

    case BranchStates.DEFAULT:
      branchInArabic = "لم يتم تحديد فرع";
      break;
    case BranchStates._6OCTOBER:
      branchInArabic = "السادس من اكتوبر";
      break;
  }
  return branchInArabic;
}

enum SectionStates { CS, BIS, ENG, DEFAULT }

String translateSectionStates(SectionStates state) {
  String sectionInArabic;

  switch (state) {
    case SectionStates.CS:
      sectionInArabic = "علوم حاسب";
      break;
    case SectionStates.BIS:
      sectionInArabic = " قسم إدارة الأعمال التكنولوجية و المعلومات";
      break;
    case SectionStates.ENG:
      sectionInArabic = "العاشر من رمضان";
      break;
    case SectionStates.DEFAULT:
      sectionInArabic = "لم يتم تحديد قسم";
      break;
  }
  return sectionInArabic;
}

Widget shimmer() => Center(
      child: SizedBox(
        width: 200.0,
        height: 100.0,
        child: Shimmer.fromColors(
          baseColor: defaultColor,
          highlightColor: Colors.white,
          child: const Text(
            'يتم الان تحميل البيانات',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
          child: const Text("حسنا"),
          onPressed: () {
            onPressedDone();
          },
        ),
        MaterialButton(
          child: const Text("إلغاء"),
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

List<SectionStates> getSections() {
  List<SectionStates> sections = [];
  sections.add((SectionStates.CS));
  sections.add((SectionStates.BIS));
  sections.add((SectionStates.ENG));
  sections.add((SectionStates.DEFAULT));
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
        title: Text(
          "إضافة وظيفة",
          textAlign: TextAlign.end,
        ),
        content: Container(
          height: 251,
          child: Column(
            children: [
              Text("اختر الوظيفة "),
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
              Text("اختر الفرع "),
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
              SizedBox(
                height: 10,
              ),
              Text("اختر الفسم "),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: double.infinity,
                child: DropdownButton<SectionStates>(
                  alignment: Alignment.center,
                  menuMaxHeight: 200,
                  underline: Container(
                    height: 0,
                    color: defaultColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  value: cubit.valueSection,
                  items: getSections().map((SectionStates value) {
                    return DropdownMenuItem<SectionStates>(
                      alignment: Alignment.center,
                      value: value,
                      child: Text(translateSectionStates(value)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      cubit.changeSection(newValue as SectionStates);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            child: const Text("حفظ"),
            onPressed: () {
              onPressedDone();
            },
          ),
          MaterialButton(
            child: const Text("إلغاء"),
            onPressed: () {
              onPressedCancel();
            },
          )
        ],
      );
    },
  );
}
