import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/di/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final providers = await createProviders();

  runApp(
    MultiProvider(
      providers: providers,
      child: const BancoPandaApp(),
    ),
  );
}
