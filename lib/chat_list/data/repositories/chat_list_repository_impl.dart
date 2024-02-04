import 'package:flutter_chat_app/chat_list/data/datasources/chat_list_data_source.dart';
import 'package:flutter_chat_app/core/typedef/app_typedef.dart';

import '../../domain/repositories/chat_list_repository.dart';

class ChatListRepositoryImpl implements ChatListRepository {
  final ChatListDataSource chatListDataSource;

  ChatListRepositoryImpl({required this.chatListDataSource});
  @override
  Future<ChatListData> getAllChats() {
    return chatListDataSource.getAllChats();
  }
}
