import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_noorisys/view/auth/forgot_password.dart';
import 'package:todo_noorisys/view/auth/registration_view.dart';
import 'package:todo_noorisys/view/profile_view.dart';
import 'package:todo_noorisys/view/task_view.dart';

import 'helper/connection_helper.dart';
import 'view/auth/login_form_view.dart';
import 'view/homescreen.dart';
import 'wrapper/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectionHelper helper = ConnectionHelper(context);
    helper.initialize();
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/resetPassword': (context) => PasswordResetScreen(),
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
