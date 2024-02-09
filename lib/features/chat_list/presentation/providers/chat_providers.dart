import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter_chat_app/features/chat/presentation/providers/private_chat_providers.dart';
import 'package:flutter_chat_app/features/chat_list/data/datasources/chat_data_source.dart';
import 'package:flutter_chat_app/features/chat_list/data/repositories/chat_repository_impl.dart';
import 'package:flutter_chat_app/features/chat_list/domain/repositories/chat_repository.dart';
import 'package:flutter_chat_app/features/chat_list/domain/usecase/get_all_chat_list_usecase.dart';
import 'package:flutter_chat_app/shared/providers/global_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';

import '../../../../shared/usecase/chat_socket_usecase.dart';
import '../../data/models/chat_reponse.dart';
import '../../domain/state/chat_list_state.dart';

final chatDataSourceProvider = Provider<ChatDataSource>(
    (ref) => ChatDataSourceImpl(dioClient: ref.watch(dioClientProvider)));

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final chatDataSource = ref.watch(chatDataSourceProvider);
  return ChatRepositoryImpl(chatDataSource: chatDataSource);
});

final getAllChatUseCaseProvider = Provider<GetAllChatListUseCase>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return GetAllChatListUseCase(chatRepository: repo);
});

//! Very very important: AUTO Dispose the provider as well to dispose the Socket Usecase*/
//! I thought: Here, autoDispose should have dispose the ChatSocketUseCase automatically which further dispose its socket. But its not happening*/

//! Very very important: AUTO Dispose the provider as well to dispose the Socket Usecase
//! Without autoDispose, the provider data is saved as it is.
//! As name suggets, disposes call of the resources when the provider is no longer used.
//! IT SIMPLY FREES UP THE MEMORY WITHOUT THE NEED OF SPECIFYING ANY DISPOSE FUNCTION MANUALLY.
//!/
final chatListProvider =
    StateNotifierProvider.autoDispose<ChatListNotifier, ChatListState>((ref) {
  return ChatListNotifier(ref.read(getAllChatUseCaseProvider),
      ref.watch(chatSocketUseCaseProvider));
});

class ChatListNotifier extends StateNotifier<ChatListState> {
  final GetAllChatListUseCase getAllChatUseCase;

  final ChatSocketUseCase chatSocketUseCase;
  ChatListNotifier(
    this.getAllChatUseCase,
    this.chatSocketUseCase,
  ) : super(ChatListState.initial()) {
    initialize();
  }
  initialize() async {
    await getAllChatList().then((value) => addChatList());

    //! Overall, this approach ensures that the 'socket-related initialization code' executes after the provider
    //! has been fully initialized, resolving the issue of socket events not being
    //! listened to when calling the function inside the constructor of the provider.

    Future.delayed(const Duration(seconds: 1), () async {
      //! Here, socket-related code is delayed because, without delaying, the code is not working, just like it is not ever called */
      //! Also, when I called this function inside build method,
      //! its working fine but when I hot reload, 'listenTo<-->Event' function is acting weird as it was called multiple
      //! times, which results in summing up newChatCount many times, even though their was only 1 to add */
      listenToEventsFromSocket();
    });
  }

  //! Here, 'broadcasted' stream is not used because, data added to it is not showing up, its always empty.
  // final chatsListStream = StreamController<List<Chat>?>.broadcast();
  final chatsListStream = BehaviorSubject<List<Chat>?>();

  @override
  void dispose() {
    chatsListStream.close();
    chatSocketUseCase.dispose();
    super.dispose();
  }

  Future<void> getAllChatList() async {
    state = state.copyWith(
        state: ChatListAllState.loading, data: null, isLoading: true);
    final data = await getAllChatUseCase.execute();
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

  void addChatList() {
    chatsListStream.add(state.data?.data?.data);
  }

  void listenToEventsFromSocket() {
    List<Chat>? chats = state.data?.data?.data;
    chatsListStream.stream.listen((event) {
      event?.forEach((element) {
        if (chats?.firstWhereOrNull((c) => c.id == element.id) == null) {
          chats?.insert(0, element);
        }
      });
    });

    listenToNewChatEvent(chats);
    listenToMessageReceivedEvent(chats);
    listenToLeaveChatEvent(chats);
  }

  void listenToNewChatEvent(List<Chat>? chats) {
    chatSocketUseCase.newChatEvent((newChat) {
      final updatedList =
          chats?.firstWhereOrNull((v) => v.id == newChat.id) == null
              ? [newChat, ...chats!]
              : [...chats!];
      chats = updatedList;
      chatsListStream.sink.add(chats);
    });
  }

  void listenToMessageReceivedEvent(List<Chat>? chats) {
    chatSocketUseCase.messageReceivedEvent((newMessage) {
      if (chats != null) {
        String foundChatId = chats
                .firstWhereOrNull((element) => element.id == newMessage.chat)
                ?.id ??
            "-";
        int index = chats.indexWhere((e) => e.id == foundChatId);
        if (index >= 0) {
          chats[index].lastMessage = newMessage;
          chats[index].isNewChat = true;
          chats[index].newChatCount += 1;
          final data = chats[index];
          chats.removeAt(index);
          chats.insert(0, data);
          chatsListStream.sink.add(chats);
        }
      }
    });
  }

  void listenToLeaveChatEvent(
    List<Chat>? chats,
  ) {
    chatSocketUseCase.leaveChatEvent((chat) {
      if (chats != null) {
        int index = chats.indexWhere((element) => element.id == chat.id);
        if (index >= 0) {
          chats.removeAt(index);
          chatsListStream.sink.add(chats);
        }
      }
    });
  }
}
