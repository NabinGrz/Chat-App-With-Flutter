import 'package:flutter_chat_app/chat_list/data/datasources/chat_data_source.dart';
import 'package:flutter_chat_app/chat_list/domain/entities/group_data_model.dart';
import 'package:flutter_chat_app/core/typedef/app_typedef.dart';

import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource chatDataSource;

  ChatRepositoryImpl({required this.chatDataSource});
  @override
  Future<ChatListData> getAllChats() async {
    return await chatDataSource.getAllChats();
  }

  @override
  Future<int> createChats(String id) async {
    return await chatDataSource.createChat(id);
  }

  @override
  Future<int> createGroupChats(GroupDataModel data) async {
    return await chatDataSource.createGroupChats(data);
  }
}
