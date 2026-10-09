import 'package:flutter/material.dart';

class BancoPandaApp extends StatelessWidget {
  const BancoPandaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BancoPanda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF239A55),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('BancoPanda', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}