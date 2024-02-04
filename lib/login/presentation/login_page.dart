import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/routes/app_routes.dart';
import 'package:flutter_chat_app/login/domain/entities/user.dart';
import 'package:flutter_chat_app/login/provider/login_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state/app_state.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.successfullAppStateResponse)));
      } else {}
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
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
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final loginRepo = ref.read(loginProvider.notifier);
                    await loginRepo.loginUser(
                      UserCredentials(
                        username: usernameController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    AppRouter.pushNamed(
                        context: context, routeName: AppRouter.register);
                  },
                  child: const Text("Register"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
