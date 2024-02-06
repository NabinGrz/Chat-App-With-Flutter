import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_list/presentation/chat_list_page.dart';
import 'package:flutter_chat_app/register/presentation/register_page.dart';

import '../../login/presentation/login_page.dart';

class AppRouter {
  const AppRouter._();
  static const register = "/register";
  static const login = "/login";
  static const chatList = "/chatList";
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case register:
        return navigate(settings, RegisterPage());
      case login:
        return navigate(settings, LoginPage());
      case chatList:
        return navigate(settings, const ChatListPage());
      default:
        throw Exception(["Route Not Found!!"]);
    }
  }

  static MaterialPageRoute<dynamic> navigate(
      RouteSettings settings, Widget widget) {
    return MaterialPageRoute<dynamic>(
        builder: (_) => widget, settings: settings);
  }

  static void pushNamed(
      {required BuildContext context, required String routeName}) {
    Navigator.pushNamed(context, routeName);
  }
}
