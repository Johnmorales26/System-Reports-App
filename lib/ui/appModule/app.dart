import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:system_reports_app/ui/expensesReportModule/expenses_report_screen.dart';
import 'package:system_reports_app/ui/profileModule/profile_screen.dart';
import 'package:system_reports_app/ui/reportAdminModule/report_admin_screen.dart';
import 'package:system_reports_app/ui/reportModule/report_screen.dart';
import 'package:system_reports_app/ui/sliderModule/slider_screen.dart';
import 'package:system_reports_app/ui/style/colors.dart';

import '../homeModule/home_screen.dart';
import '../signInModule/sign_in_screen.dart';
import '../registerModule/sign_up_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const MaterialTheme materialTheme = MaterialTheme(TextTheme());

    return MaterialApp(
        title: 'System Reports',
        debugShowCheckedModeBanner: false,
        initialRoute: _authenticationVerification(),
        theme: materialTheme.light(),
        darkTheme: materialTheme.dark(),
        routes: {
          SliderScreen.route: (context) => SliderScreen(),
          SignInScreen.route: (context) => const SignInScreen(),
          SignUpScreen.route: (context) => const SignUpScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          ReportScreen.route: (context) => const ReportAdminScreen(),
          ExpensesReportScreen.route: (context) => const ExpensesReportScreen(),
          ProfileScreen.route: (context) => const ProfileScreen()
        });
  }

  String _authenticationVerification() {
    if (FirebaseAuth.instance.currentUser != null) {
      return HomeScreen.route;
    } else {
      return SliderScreen.route;
    }
  }
}
