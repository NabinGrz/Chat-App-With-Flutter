import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat/data/datasources/private_chat_data_source.dart';
import 'package:flutter_chat_app/features/chat/data/models/private_chat_model.dart';
import 'package:flutter_chat_app/features/chat/data/repositories/private_chat_repositories_impl.dart';
import 'package:flutter_chat_app/features/chat/domain/repositories/private_chat_repositories.dart';
import 'package:flutter_chat_app/features/chat/domain/usecase/private_chat_usecase.dart';
import 'package:flutter_chat_app/shared/providers/global_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/usecase/chat_socket_usecase.dart';
import '../../../chat_list/data/models/message_reponse.dart';
import '../../data/models/message_send_model.dart';

final privateChatDataSourceProvider = Provider<PrivateChatDataSource>((ref) =>
    PrivateChatDataSourceImpl(dioClient: ref.watch(dioClientProvider)));

final privateChatRepositoryProvider = Provider<PrivateChatDataRepository>(
    (ref) => PrivateChatRepositoryImpl(
        privateChatDataSource: ref.watch(privateChatDataSourceProvider)));

final privateChatUseCaseProvider = Provider<PrivateChatUseCase>((ref) =>
    PrivateChatUseCase(
        privateChatDataRepository: ref.watch(privateChatRepositoryProvider)));

final privateChatProvider =
    ChangeNotifierProvider.autoDispose<PrivateChatNotifier>(
        (ref) => PrivateChatNotifier(
              privateChatUseCase: ref.watch(privateChatUseCaseProvider),
              userID: ref.watch(userIDProvider),
              chatSocketUseCase: ref.watch(chatSocketUseCaseProvider),
              // ref.read(provider)
            ));

final userIDProvider = StateProvider<String>((ref) => "");
final myUserIDProvider = StateProvider<String>((ref) => "");
// final showIconProvider = StateProvider<bool>((ref) => false);
final selectedImagesProvider = StateProvider<File?>((ref) => null);
final typingProvider = StateProvider<bool>((ref) => false);

final dataProvider = FutureProvider((ref) async {
  final preference = await SharedPreferences.getInstance();
  ref.read(myUserIDProvider.notifier).state = preference.getString('id') ?? "";
});
final showIconProvider =
    StateNotifierProvider<SendIconNotifier, bool>((ref) => SendIconNotifier());

class SendIconNotifier extends StateNotifier<bool> {
  SendIconNotifier() : super(false);

  bool get show => state;

  toggle(String value) => state = value != "";
}

class PrivateChatNotifier extends ChangeNotifier {
  final PrivateChatUseCase privateChatUseCase;
  final String userID;
  final ChatSocketUseCase chatSocketUseCase;
  bool isLoading = false;
  bool messageSend = false;
  bool enableButton = false;
  bool isTyping = false;
  String? typingUser;
  String? errorMessage;
  PrivateChatNotifier({
    required this.userID,
    required this.privateChatUseCase,
    required this.chatSocketUseCase,
  }) {
    initialize();
  }

  // @override
  // void dispose() {
  //   streamController.close();
  //   chatSocketUseCase.dispose();
  //   super.dispose();
  // }

  final streamController = BehaviorSubject<List<Message>>();
  List<Message>? get chats => streamController.valueOrNull;
  initialize() async {
    await getMessages(userID);
    await joinChat(userID);
    await Future.delayed(const Duration(seconds: 1), () {
      chatSocketUseCase.messageReceivedEvent(
        (message) {
          debugPrint("Message From Provider: $message");
          if (chats != null) {
            streamController.add([...chats!, message]);
          }
        },
      );
      chatSocketUseCase.typingEvent(
        (id) {
          print("USER TYPING: $id");
          isTyping = true;
          typingUser = id;
          notifyListeners();
        },
      );
      chatSocketUseCase.stoptypingEvent(
        (id) {
          print("USER TYPING: $id");
          isTyping = false;
          typingUser = id;
          notifyListeners();
        },
      );
    });
  }

  void enableSendButton() {
    enableButton = true;
    notifyListeners();
  }

  void disableSendButton() {
    enableButton = false;
    notifyListeners();
  }

  Future<void> getMessages(String userID) async {
    isLoading = true;
    PrivateChatModel messages = await privateChatUseCase.execute(userID);
    if (messages.statusCode == 200 &&
        messages.data != null &&
        messages.data!.isNotEmpty) {
      streamController.add(messages.data!.reversed.toList());
    } else {}
    isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(FormData data, String userID, bool isImage) async {
    isLoading = true;
    MessageSendResponse response =
        await privateChatUseCase.sendMessage(data, userID, isImage);
    messageSend = response.success == true;
    errorMessage = response.message;
    isLoading = false;
    if (chats != null) {
      if (response.data != null) {
        _addMessage([...chats!, response.data!]);
      }
    } else {
      if (response.data != null) {
        _addMessage([response.data!]);
      }
    }

    notifyListeners();
  }

  _addMessage(List<Message> messages) => streamController.add(messages);

  void startTyping(String id) {
    chatSocketUseCase.emitTypingEvent(id);
  }

  void stopTyping(String id) {
    chatSocketUseCase.emitStopTypingEvent(id);
  }

  Future<void> joinChat(String id) async {
    chatSocketUseCase.joinChatEvent(id);
  }
}
