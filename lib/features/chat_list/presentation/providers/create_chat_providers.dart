import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/group_data_model.dart';
import '../../domain/usecase/create_chat_usecase.dart';
import '../../domain/usecase/create_group_chat_usecase.dart';
import 'chat_providers.dart';

final createChatUseCaseProvider = Provider<CreateChatUseCase>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return CreateChatUseCase(chatRepository: repo);
});

final createGroupChatUseCaseProvider = Provider<CreateGroupChatUseCase>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return CreateGroupChatUseCase(chatRepository: repo);
});

final createChatProvider = ChangeNotifierProvider<CreateChatNotifier>((ref) {
  final notifier = ref.read(chatListProvider.notifier);
  return CreateChatNotifier(
      createChatUseCase: ref.read(createChatUseCaseProvider),
      createGroupChatUseCase: ref.read(createGroupChatUseCaseProvider),
      notifier: notifier);
});

class CreateChatNotifier extends ChangeNotifier {
  final CreateChatUseCase createChatUseCase;
  final CreateGroupChatUseCase createGroupChatUseCase;
  final ChatListNotifier notifier;

  CreateChatNotifier(
      {required this.createGroupChatUseCase,
      required this.notifier,
      required this.createChatUseCase});
  bool isCreating = false;
  bool isSuccess = false;
  Future<void> createChat(String id) async {
    isCreating = true;
    final statuseCode = await createChatUseCase.execute(id);
    isCreating = false;
    isSuccess = statuseCode == 200;
    notifyListeners();
  }

  void reset() {
    isSuccess = false;
    notifyListeners();
  }

  Future<void> createGroupChat(GroupDataModel data) async {
    isCreating = true;
    final statuseCode = await createGroupChatUseCase.execute(data);
    isCreating = false;
    isSuccess = statuseCode == 200;
    notifyListeners();
  }
}
