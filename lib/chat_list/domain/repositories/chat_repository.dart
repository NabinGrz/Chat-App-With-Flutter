import 'package:flutter_chat_app/core/typedef/app_typedef.dart';

abstract class ChatRepository {
  Future<ChatListData> getAllChats();
  Future<int> createChats();
}
