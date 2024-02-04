import 'package:dio/dio.dart';
import 'package:flutter_chat_app/login/data/datasources/login_data_source.dart';
import 'package:flutter_chat_app/login/data/repositories/login_repository_implentation.dart';
import 'package:flutter_chat_app/login/domain/entities/user.dart';
import 'package:flutter_chat_app/login/domain/usecases/login_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../presentation/state/app_state.dart';

final loginDataSourceProvider =
    Provider((ref) => LoginDataSourceImpl(dioClient: Dio()));

final loginRepositoryProvider = Provider<LoginRepositoryImpl>((ref) {
  final LoginDataSource loginDataSource = ref.watch(loginDataSourceProvider);
  return LoginRepositoryImpl(loginDataSource: loginDataSource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final loginRepository = ref.watch(loginRepositoryProvider);
  return LoginUseCase(loginRepository: loginRepository);
});

final loginProvider = StateNotifierProvider<LoginNotifier, AppState>((ref) {
  final loginUseCase = ref.read(loginUseCaseProvider);
  return LoginNotifier(loginUseCase);
});

class LoginNotifier extends StateNotifier<AppState> {
  final LoginUseCase _loginUseCase;

  LoginNotifier(this._loginUseCase) : super(const AppState.initial());

  Future<void> loginUser(UserCredentials userCredentials) async {
    state = const AppState.loading();
    final response = await _loginUseCase.execute(userCredentials);
    state = response.$1 != null
        ? AppState.success(response.$1!.message)
        : AppState.failure(response.$2!.message!);
  }
}
