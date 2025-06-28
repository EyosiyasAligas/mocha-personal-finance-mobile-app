import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/route/app_route.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(MyApp(router: getGoRouterOfTheApp()));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mocha Personal Finance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
