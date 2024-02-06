import 'dart:async';

import 'package:flutter_chat_app/chat_list/domain/repositories/chat_repository.dart';
import 'package:flutter_chat_app/core/typedef/app_typedef.dart';

class GetAllChatListUseCase {
  final ChatRepository chatRepository;

  GetAllChatListUseCase({required this.chatRepository});

  Future<ChatListData> execute() async {
    return await chatRepository.getAllChats();
  }
}
