import 'package:dio/dio.dart';
import 'package:flutter_chat_app/register/data/datasources/register_data_source.dart';
import 'package:flutter_chat_app/register/domain/entities/register_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/auth_state/auth_state.dart';
import '../../data/repositories/register_repository_implementation.dart';
import '../../domain/usecase/register_usecase.dart';

final registerDataSourceProvider =
    Provider((ref) => RegisterDataSourceImpl(dioClient: Dio()));

final registerRepositoryProvider = Provider<RegisterRepositoryImpl>((ref) {
  final RegisterDataSource registerDataSource =
      ref.watch(registerDataSourceProvider);
  return RegisterRepositoryImpl(registerDataSource: registerDataSource);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final registerRepository = ref.watch(registerRepositoryProvider);
  return RegisterUseCase(registerRepository: registerRepository);
});

final registerProvider =
    StateNotifierProvider<RegisterNotifier, AuthState>((ref) {
  final registerUseCase = ref.read(registerUseCaseProvider);
  return RegisterNotifier(registerUseCase);
});

class RegisterNotifier extends StateNotifier<AuthState> {
  final RegisterUseCase _registerUseCase;

  RegisterNotifier(this._registerUseCase) : super(const AuthState.initial());

  Future<void> registerUser(RegisterData userCredentials) async {
    state = const AuthState.loading();
    final response = await _registerUseCase.execute(userCredentials);
    state = response.$1 != null
        ? AuthState.success(response.$1!)
        : AuthState.failure(response.$2!);
  }
}
