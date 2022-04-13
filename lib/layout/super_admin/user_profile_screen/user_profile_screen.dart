import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hti_store/layout/super_admin/search_users_screen/search_users_screen.dart';
import 'package:hti_store/layout/super_admin/user_profile_screen/cubit/cubit.dart';
import 'package:hti_store/layout/super_admin/user_profile_screen/cubit/states.dart';
import 'package:hti_store/shared/components/components.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserProfileCubit(),
      child: BlocConsumer<UserProfileCubit, UserProfileStates>(
        listener: (context, state) {
          var cubit = UserProfileCubit.get(context);
        },
        builder: (context, state) {
          var cubit = UserProfileCubit.get(context);
          double width = 20.0;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "اسم الموظف",
                style: TextStyle(fontSize: 25),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          "الاسم بالكامل",
                          style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 17)),
                        ),
                      ),
                      SizedBox(
                        width: width,
                      ),
                      Text(
                        "Ahmed Hassen",
                        style: GoogleFonts.outfit(
                            textStyle: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  myDivider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          "البريد الالكتروني",
                          style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 17)),
                        ),
                      ),
                      SizedBox(
                        width: width,
                      ),
                      Text(
                        "gg@gmail.com",
                        style: GoogleFonts.outfit(
                            textStyle: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  myDivider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          "الوظيفه",
                          style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 17)),
                        ),
                      ),
                      SizedBox(
                        width: width,
                      ),
                      Text(
                        "امين المخازن",
                        style: GoogleFonts.outfit(
                            textStyle: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  myDivider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          "القسم",
                          style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 17)),
                        ),
                      ),
                      SizedBox(
                        width: width,
                      ),
                      Text(
                        "علوم حاسب",
                        style: GoogleFonts.outfit(
                            textStyle: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  myDivider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          "الفرع",
                          style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 17)),
                        ),
                      ),
                      SizedBox(
                        width: width,
                      ),
                      Text(
                        "العاشر",
                        style: GoogleFonts.outfit(
                            textStyle: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
