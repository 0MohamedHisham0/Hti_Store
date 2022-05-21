import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hti_store/modules/splash/splash_screen.dart';
import 'package:hti_store/modules/suppliers/all_products_screens/cubit/cubit.dart';
import 'package:hti_store/shared/bloc_observer.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';
import 'package:hti_store/shared/styles/themes.dart';
import 'dart:io' show Platform;

import 'modules/orders/orders_screen/cubit/cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: 'isDark');

  runApp(MyApp(
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;

  MyApp({
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AllProductsCubit()
              ..getPermanentProducts()
              ..getConsumerProducts(),
          ),
          BlocProvider(
            create: (context) =>
                OrdersCubit()..getOrdersFromAPIWithBottomMenu(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          home: const Directionality(
              textDirection: TextDirection.rtl, child: SplashScreen()),
        ));
  }
}
