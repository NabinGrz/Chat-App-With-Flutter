import 'dart:async';

import 'package:flutter_chat_app/features/chat_list/domain/repositories/chat_repository.dart';

class CreateChatUseCase {
  final ChatRepository chatRepository;

  CreateChatUseCase({required this.chatRepository});

  Future<int> execute(String id) async {
    return await chatRepository.createChats(id);
  }
}
