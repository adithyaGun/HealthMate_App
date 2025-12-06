import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constant.dart';
import 'features/auth/view/login_screen.dart';
import 'features/auth/view_model/auth_view_model.dart';
import 'features/health_records/view/dashboard_screen.dart';
import 'features/health_records/view/add_record_screen.dart';
import 'features/health_records/view/health_record_list.dart';
import 'features/health_records/view_model/health_record_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HealthRecordViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 1,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16),
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/records': (context) => const HealthRecordListScreen(),
          '/add-record': (context) => const AddRecordScreen(),
        },
        builder: (context, child) {
          
          return child!;
        },
      ),
    );
  }
}