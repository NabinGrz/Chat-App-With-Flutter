import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/login/presentation/login_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/routes/app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
      key: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
        fontFamily: "Poppins",
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: LoginPage(),
    );
  }
}
