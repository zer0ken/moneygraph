import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneygraph/constants/app_theme.dart';
import 'package:moneygraph/services/database_service.dart';
import 'package:moneygraph/viewmodels/transaction_view_model.dart';
import 'package:moneygraph/views/responsive_screen.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart' as window_size;
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 데스크톱 플랫폼에서만 윈도우 크기 제한 설정
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    window_size.setWindowMinSize(const Size(360, 640)); // 일반적인 모바일 최소 크기
    window_size.setWindowTitle('Money Graph');
  }

  // 세로 모드로 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        ChangeNotifierProxyProvider<DatabaseService, TransactionViewModel>(
          create: (context) => TransactionViewModel(context.read<DatabaseService>()),
          update: (context, database, previous) => 
            previous ?? TransactionViewModel(database),
        ),
      ],      child: MaterialApp(
        title: 'Money Graph',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: Scaffold(
          body: const ResponsiveScreen(),
        ),
      ),
    );
  }
}
