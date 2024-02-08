// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_chat_app/features/chat_list/data/models/chat_list_response.dart';

import '../../../../core/typedef/app_typedef.dart';
import '../../../../shared/api/typed_response.dart';

enum ChatListAllState {
  initial,
  loading,
  loaded,
  failure,
  fetchingMore,
  fetchedAllProducts
}

class ChatListState {
  final ChatListAllState state;
  final ChatListData? data;
  final bool isLoading;
  final bool isDataLoaded;

  ChatListState(
      {required this.isDataLoaded,
      required this.isLoading,
      required this.state,
      this.data});

  ChatListState.initial({
    this.state = ChatListAllState.initial,
    this.isLoading = false,
    this.isDataLoaded = false,
    this.data,
  });

  @override
  bool operator ==(covariant ChatListState other) {
    if (identical(this, other)) return true;

    return other.state == state && other.data == data;
  }

  @override
  int get hashCode => state.hashCode ^ data.hashCode;

  @override
  String toString() => 'ChatListState(state: $state, data: $data)';

  ChatListState copyWith(
      {ChatListAllState? state,
      DataResponse<ChatListResponse>? data,
      required bool isLoading,
      bool? isDataLoaded}) {
    return ChatListState(
        state: state ?? this.state,
        data: data ?? this.data,
        isDataLoaded: isDataLoaded ?? this.isDataLoaded,
        isLoading: isLoading);
  }
}
