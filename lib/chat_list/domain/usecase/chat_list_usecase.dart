import 'dart:async';

import 'package:flutter_chat_app/chat_list/domain/repositories/chat_list_repository.dart';
import 'package:flutter_chat_app/core/typedef/app_typedef.dart';

class GetAllChatListUseCase {
  final ChatListRepository chatListRepository;

  GetAllChatListUseCase({required this.chatListRepository});

  Future<ChatListData> execute() async {
    return await chatListRepository.getAllChats();
  }

  // void addToStream(ChatListData event) => chatsListStream.add(event);
}
