import 'package:flutter_chat_app/chat_list/data/repositories/user_repository_impl.dart';
import 'package:flutter_chat_app/chat_list/domain/repositories/user_repository.dart';
import 'package:flutter_chat_app/chat_list/domain/usecase/user_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/providers/global_providers.dart';
import '../../data/datasources/user_data_source.dart';
import '../../data/models/user_model.dart';

final userDataSourceProvider = Provider<UserDataSource>(
    (ref) => UserDataSourceImpl(dioClient: ref.watch(dioClientProvider)));

final userRepositoryProvider = Provider<UserRepository>((ref) =>
    UserRepositoryImpl(userDataSource: ref.watch(userDataSourceProvider)));

final userUseCaseProvider = Provider<UserUseCase>((ref) {
  return UserUseCase(userRepository: ref.watch(userRepositoryProvider));
});

final userIdProvider = StateProvider<String?>((ref) => null);
final isGroupChatProvider = StateProvider<bool>((ref) => false);
final participantsProvider = StateProvider<List<Datum>?>((ref) => null);
final testProvider = StateProvider<List<String>>((ref) => []);
final userProvider = FutureProvider<UserModel>((ref) {
  final useCase = ref.watch(userUseCaseProvider);
  return useCase.getAllUsers();
});
