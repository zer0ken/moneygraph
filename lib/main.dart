import 'package:flutter/material.dart';
import 'package:moneygraph/constants/app_theme.dart';
import 'package:moneygraph/views/overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Graph',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const OverviewScreen(),
    );
  }
}
