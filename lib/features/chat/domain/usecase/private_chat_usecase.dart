import 'package:dio/dio.dart';
import 'package:flutter_chat_app/features/chat/data/models/private_chat_model.dart';
import 'package:flutter_chat_app/features/chat/domain/repositories/private_chat_repositories.dart';

import '../../data/models/message_send_model.dart';

class PrivateChatUseCase {
  final PrivateChatDataRepository privateChatDataRepository;

  PrivateChatUseCase({required this.privateChatDataRepository});
  Future<PrivateChatModel> execute(String userID) async {
    return await privateChatDataRepository.getMessages(userID);
  }

  Future<MessageSendResponse> sendMessage(FormData data, String userID) async {
    return await privateChatDataRepository.sendMessage(data, userID);
  }
}
