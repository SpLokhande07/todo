import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_noorisys/view/auth/forgot_password.dart';
import 'package:todo_noorisys/view/auth/registration_view.dart';
import 'package:todo_noorisys/view/profile_view.dart';
import 'package:todo_noorisys/view/task_view.dart';

import 'helper/connection_helper.dart';
import 'view/auth/login_form_view.dart';
import 'view/homescreen.dart';
import 'wrapper/auth_wrapper.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ScreenUtil.ensureScreenSize();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectionHelper helper = ConnectionHelper(context);
    helper.initialize();
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Todo App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: AuthWrapper(),
            builder: FToastBuilder(),
            navigatorKey: navigatorKey,
            routes: {
              '/login': (context) => LoginScreen(),
              '/register': (context) => RegistrationScreen(),
              '/resetPassword': (context) => PasswordResetScreen(),
              '/profile': (context) => ProfileScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        });
  }
}
