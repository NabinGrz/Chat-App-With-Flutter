import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_list/data/datasources/chat_list_data_source.dart';
import 'package:flutter_chat_app/chat_list/data/repositories/chat_list_repository_impl.dart';
import 'package:flutter_chat_app/chat_list/domain/repositories/chat_list_repository.dart';
import 'package:flutter_chat_app/chat_list/domain/usecase/chat_list_usecase.dart';
import 'package:flutter_chat_app/shared/usecase/socket_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/socket_events.dart';
import '../../data/models/chat_reponse.dart';
import '../../domain/state/chat_list_state.dart';

final chatListDataSourceProvider = Provider<ChatListDataSource>(
    (ref) => ChatListDataSourceImpl(dioClient: Dio()));

final chatListRepositoryProvider = Provider<ChatListRepository>((ref) {
  final chatListDataSource = ref.watch(chatListDataSourceProvider);
  return ChatListRepositoryImpl(chatListDataSource: chatListDataSource);
});

final useCaseProvider = Provider<GetAllChatListUseCase>((ref) {
  final repo = ref.watch(chatListRepositoryProvider);
  return GetAllChatListUseCase(chatListRepository: repo);
});

//! Very very important: AUTO Dispose the provider as well to dispose the Socket Usecase*/
//! I thought: Here, autoDispose should have dispose the ChatSocketUseCase automatically which further dispose its socket. But its not happening*/
final chatSocketUseCaseProvider =
    Provider.autoDispose<ChatSocketUseCase>((ref) {
  return ChatSocketUseCase();
});

//! Very very important: AUTO Dispose the provider as well to dispose the Socket Usecase
//! Without autoDispose, the provider data is saved as it is.
//! As name suggets, disposes call of the resources when the provider is no longer used.
//! IT SIMPLY FREES UP THE MEMORY WITHOUT THE NEED OF SPECIFYING ANY DISPOSE FUNCTION MANUALLY.
//!/
final chatListProvider =
    StateNotifierProvider.autoDispose<ChatListNotifier, ChatListState>((ref) {
  return ChatListNotifier(
      ref.read(useCaseProvider), ref.read(chatSocketUseCaseProvider));
});

class ChatListNotifier extends StateNotifier<ChatListState> {
  final GetAllChatListUseCase useCase;
  final ChatSocketUseCase socketUseCase;
  ChatListNotifier(this.useCase, this.socketUseCase)
      : super(ChatListState.initial()) {
    getAllChatList().then((value) => addChatList(state.data?.data?.data));
  }
  // final chatsListStream = StreamController<List<Chat>?>.broadcast();
  final chatsListStream = StreamController<List<Chat>?>();

  @override
  void dispose() {
    chatsListStream.close();
    socketUseCase.dispose();
    super.dispose();
  }

  Future<void> getAllChatList() async {
    state = state.copyWith(
        state: ChatListAllState.loading, data: null, isLoading: true);
    final data = await useCase.execute();
    if (data.data?.statusCode == 200 || data.data?.statusCode == 201) {
      state = state.copyWith(
        state: ChatListAllState.fetchedAllProducts,
        data: data,
        isLoading: false,
        isDataLoaded: true,
      );
    } else {
      state = state.copyWith(
        state: ChatListAllState.failure,
        data: data,
        isLoading: false,
        isDataLoaded: true,
      );
    }
  }

  void addChatList(List<Chat>? data) {
    chatsListStream.add(data);
  }

  void listenToEventsFromSocket(BuildContext context) {
    List<Chat>? chats = state.data?.data?.data;

    socketUseCase.listenToEvent(
        eventName: SocketEvents.newChatEvent,
        handler: (value) {
          // ? When added in group chat or new 1 on 1 chat
          final newChat = Chat.fromJson(value as Map<String, dynamic>);
          final updatedList = [newChat, ...chats!];
          chats = updatedList;
          chatsListStream.sink.add(chats);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.green,
              content: Text("New Chat Alert!!")));
        });

    socketUseCase.listenToEvent(
      eventName: SocketEvents.leaveChatEvent,
      handler: (value) {
        final chat = Chat.fromJson(value as Map<String, dynamic>);
        if (chats != null) {
          int index = chats!.indexWhere((element) => element.id == chat.id);
          if (index >= 0) {
            chats!.removeAt(index);
            chatsListStream.sink.add(chats);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Deleted Chat Alert!!")));
          }
        }
      },
    );
  }
}
