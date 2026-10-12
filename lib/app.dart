import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_view_model.dart';
import 'features/auth/viewmodel/auth_view_model.dart';

class BancoPandaApp extends StatefulWidget {
  const BancoPandaApp({super.key});

  @override
  State<BancoPandaApp> createState() => _BancoPandaAppState();
}

class _BancoPandaAppState extends State<BancoPandaApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(context.read<AuthViewModel>());
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeViewModel>().mode;

    return MaterialApp.router(
      title: 'BancoPanda',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
