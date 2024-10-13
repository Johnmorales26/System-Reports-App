import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:system_reports_app/ui/appModule/app.dart';
import 'package:system_reports_app/ui/expensesReportModule/expenses_report_view_model.dart';
import 'package:system_reports_app/ui/homeModule/home_view_model.dart';
import 'package:system_reports_app/ui/homeModule/widgets/reports_view_model.dart';
import 'package:system_reports_app/ui/profileModule/profile_view_model.dart';
import 'package:system_reports_app/ui/registerModule/sign_up_view_model.dart';
import 'package:system_reports_app/ui/reportAdminModule/report_admin_view_model.dart';
import 'package:system_reports_app/ui/reportModule/report_view_model.dart';
import 'firebase_options.dart';
import 'package:system_reports_app/ui/signInModule/sign_in_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SignInViewModel()),
      ChangeNotifierProvider(create: (_) => SignUpViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ChangeNotifierProvider(create: (_) => ReportViewModel()),
      ChangeNotifierProvider(create: (_) => ReportAdminViewModel()),
      ChangeNotifierProvider(create: (_) => ExpensesReportViewModel()),
      ChangeNotifierProvider(create: (_) => ReportsInnerViewModel()),
      ChangeNotifierProvider(create: (_) => ProfileViewModel())
    ],
    child: const App()
  ));
}