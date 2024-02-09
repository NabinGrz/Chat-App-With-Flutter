import 'package:dio/src/form_data.dart';
import 'package:flutter_chat_app/features/chat/data/datasources/private_chat_data_source.dart';
import 'package:flutter_chat_app/features/chat/data/models/private_chat_model.dart';
import 'package:flutter_chat_app/features/chat/domain/repositories/private_chat_repositories.dart';

import '../models/message_send_model.dart';

class PrivateChatRepositoryImpl extends PrivateChatDataRepository {
  final PrivateChatDataSource privateChatDataSource;

  PrivateChatRepositoryImpl({required this.privateChatDataSource});
  @override
  Future<PrivateChatModel> getMessages(String userID) async {
    return await privateChatDataSource.getMessages(userID);
  }

  @override
  Future<MessageSendResponse> sendMessage(FormData data, String userID) async {
    return await privateChatDataSource.sendMessage(data, userID);
  }
}
