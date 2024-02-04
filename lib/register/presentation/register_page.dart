import 'package:flutter/material.dart';
import 'package:flutter_chat_app/register/domain/entities/register_data.dart';
import 'package:flutter_chat_app/register/presentation/providers/register_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/routes/app_routes.dart';
import '../../login/presentation/state/app_state.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final registerRepo = ref.read(registerProvider.notifier);
    ref.listen(
        registerProvider.select(
          (value) => value,
        ), (previous, next) {
      if (next is Failure) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text("Registeration Failed"),
            content: Text(next.failedAppStateResponse),
          ),
        );
      } else if (next is Success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.successfullAppStateResponse)));
        Navigator.pop(context);
      } else {}
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
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
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await registerRepo.registerUser(
                      RegisterData(
                        username: usernameController.text,
                        password: passwordController.text,
                        email: emailController.text,
                      ),
                    );
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
