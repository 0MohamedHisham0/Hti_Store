import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/modules/login/login_screen.dart';
import 'package:hti_store/modules/on_boarding/on_boarding_screen.dart';
import 'package:hti_store/modules/suppliers/all_products_screens/cubit/cubit.dart';
import 'package:hti_store/shared/bloc_observer.dart';
import 'package:hti_store/shared/components/constants.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';
import 'package:hti_store/shared/styles/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: 'isDark');
  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  String? token = CacheHelper.getData(key: 'token');
  String? userRole = CacheHelper.getData(key: 'userRole');
  if (onBoarding != null) {
    if (token != null && userRole != null) {
      widget = getHomeScreen(userRole);
    } else {
      widget = LoginScreen();
      print("LoginScreen");
    }
  } else {
    widget = const OnBoardingScreen();
    print("OnBoardingScreen");
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AllProductsCubit()
              ..getPermanentProducts()
              ..getConsumerProducts(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          home: Directionality(
              textDirection: TextDirection.rtl, child: startWidget!),
        ));
  }
}
