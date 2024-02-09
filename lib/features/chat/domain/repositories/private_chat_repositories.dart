import 'package:dio/dio.dart';

import '../../data/models/message_send_model.dart';
import '../../data/models/private_chat_model.dart';

abstract class PrivateChatDataRepository {
  Future<PrivateChatModel> getMessages(String userID);
  Future<MessageSendResponse> sendMessage(
      FormData data, String userID, bool isImage);
}
