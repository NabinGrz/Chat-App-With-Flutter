import 'dart:async';

import 'package:flutter_chat_app/chat_list/domain/repositories/chat_repository.dart';

import '../entities/group_data_model.dart';

class CreateGroupChatUseCase {
  final ChatRepository chatRepository;

  CreateGroupChatUseCase({required this.chatRepository});

  Future<int> execute(GroupDataModel data) async {
    return await chatRepository.createGroupChats(data);
  }
}
