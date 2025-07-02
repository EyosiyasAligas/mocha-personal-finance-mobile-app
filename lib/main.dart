import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'config/firebase_remote_config.dart';
import 'core/route/app_route.dart';
import 'core/service_locator/service_locator.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
  runApp(MyApp(router: getGoRouterOfTheApp()));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    final configService = sl<RemoteConfigService>();

    return ValueListenableBuilder(
      valueListenable: configService.themeConfigNotifier,
      builder: (context, config, _) {
        final lightPrimary = config.lightPrimary;
        final lightSecondary = config.lightSecondary;
        final darkPrimary = config.darkPrimary;
        final darkSecondary = config.darkSecondary;

        final lightScheme = ColorScheme.light(
          primary: lightPrimary,
          onPrimary: lightSecondary,
          secondary: AppColors.secondaryLight,
          onSecondary: AppColors.onSecondaryLight,
          tertiary: AppColors.tertiaryLight,
          onTertiary: AppColors.onTertiaryLight,
          surface: AppColors.scaffoldBackgroundLight,
          onSurface: AppColors.primaryTextLight,
          error: AppColors.errorLight,
          onError: AppColors.white,
        );

        final darkScheme = ColorScheme.dark(
          primary: darkPrimary,
          onPrimary: AppColors.onPrimaryDark,
          secondary: darkSecondary,
          onSecondary: AppColors.onSecondaryDark,
          tertiary: AppColors.tertiaryDark,
          onTertiary: AppColors.onTertiaryDark,
          surface: AppColors.scaffoldBackgroundDark,
          onSurface: AppColors.primaryTextDark,
          error: AppColors.errorDark,
          onError: AppColors.black,
        );
        return MaterialApp.router(
          title: 'Mocha Personal Finance',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme.copyWith(colorScheme: lightScheme),
          darkTheme: AppTheme.darkTheme.copyWith(colorScheme: darkScheme),
          // theme: AppTheme.lightTheme
          //   ..colorScheme.copyWith(
          //     primary: lightPrimary,
          //     secondary: lightSecondary,
          //   ),
          // darkTheme: AppTheme.darkTheme
          //   ..colorScheme.copyWith().copyWith(
          //     primary: darkPrimary,
          //     secondary: darkSecondary,
          //   ),
          routerConfig: router,
        );
      },
    );
  }
}
