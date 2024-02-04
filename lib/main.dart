import 'package:flutter/material.dart';
import 'package:flutter_chat_app/login/presentation/login_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/routes/app_routes.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: LoginPage(),
    );
  }
}
