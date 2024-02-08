import 'package:flutter_chat_app/features/chat_list/domain/entities/group_data_model.dart';
import 'package:flutter_chat_app/core/typedef/app_typedef.dart';

abstract class ChatRepository {
  Future<ChatListData> getAllChats();
  Future<int> createChats(String id);
  Future<int> createGroupChats(GroupDataModel data);
}
