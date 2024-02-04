import 'package:flutter_chat_app/core/typedef/app_typedef.dart';

abstract class ChatListRepository {
  Future<ChatListData> getAllChats();
}
