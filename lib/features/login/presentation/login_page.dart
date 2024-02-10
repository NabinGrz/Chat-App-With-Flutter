import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/app_colors.dart';
import 'package:flutter_chat_app/core/constants/app_text_style.dart';
import 'package:flutter_chat_app/core/routes/app_routes.dart';
import 'package:flutter_chat_app/features/login/domain/entities/user.dart';
import 'package:flutter_chat_app/features/login/provider/login_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/auth_state/auth_state.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  // final usernameController = TextEditingController();
  // final passwordController = TextEditingController();
  final usernameController = TextEditingController(text: "nabin");
  final passwordController = TextEditingController(text: "nabin");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    ref.listen(
        loginProvider.select(
          (value) => value,
        ), (previous, next) {
      if (next is Failure) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text("Login Failed"),
            content: Text(next.failedAppStateResponse),
          ),
        );
      } else if (next is Success) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(next.successfullAppStateResponse)));
        AppRouter.pushNamed(context: context, routeName: AppRouter.chatList);
      } else {}
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: AppColors.primary,
        backgroundColor: Colors.white, elevation: 0,
        title: Text(
          "Simple Chat Application",
          style: AppTextStyle.regular(color: Colors.black),
        ),
      ),
      body: state.maybeMap(
        loading: (value) =>
            const Center(child: CircularProgressIndicator.adaptive()),
        orElse: () {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: AppTextStyle.semiBold(fontSize: 35),
                ),
                const SizedBox(
                  height: 60,
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Username....",
                    hintStyle: AppTextStyle.extraLight(),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  style: AppTextStyle.regular(),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  style: AppTextStyle.regular(),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: AppTextStyle.extraLight(),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(200, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () async {
                    final notifier = ref.read(loginProvider.notifier);
                    await notifier.loginUser(
                      UserCredentials(
                        username: usernameController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                  child: Text(
                    "Login",
                    style: AppTextStyle.semiBold(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppTextStyle.regular(),
                    ),
                    TextButton(
                      onPressed: () async {
                        AppRouter.pushNamed(
                            context: context, routeName: AppRouter.register);
                      },
                      child: Text(
                        "Register",
                        style: AppTextStyle.semiBold(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
