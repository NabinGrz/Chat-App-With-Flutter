import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_chat_app/chat_list/data/datasources/chat_list_data_source.dart';
import 'package:flutter_chat_app/chat_list/data/repositories/chat_list_repository_impl.dart';
import 'package:flutter_chat_app/chat_list/domain/repositories/chat_list_repository.dart';
import 'package:flutter_chat_app/chat_list/domain/usecase/chat_list_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/typedef/app_typedef.dart';
import '../../../shared/api/typed_response.dart';
import '../../data/models/chat_list_response.dart';
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

// final chatListProvider =
//     StateNotifierProvider<ChatListNotifier, ChatListState>((ref) {
//   return ChatListNotifier(ref.read(useCaseProvider));
// });

// class ChatListNotifier extends StateNotifier<ChatListState> {
//   final GetAllChatListUseCase useCase;
//   ChatListNotifier(this.useCase) : super(ChatListState.initial());

//   final chatsListStream = StreamController<ChatListData>();

//   Future<void> getAllChatList() async {
//     state = state.copyWith(state: ChatListAllState.loading, data: null);
//     final data = await useCase.execute();
//     state = state.copyWith(
//       state: ChatListAllState.fetchedAllProducts,
//       data: data,
//     );
//     state;
//   }
// }

final chatListProvider = FutureProvider<ChatListData>((ref) {
  final useCase = ref.watch(useCaseProvider);
  return useCase.execute();
});
