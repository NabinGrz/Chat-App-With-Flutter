import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_list/data/models/chat_reponse.dart';
import 'package:flutter_chat_app/chat_list/domain/state/chat_list_state.dart';
import 'package:flutter_chat_app/chat_list/presentation/providers/chat_list_providers.dart';
import 'package:flutter_chat_app/shared/usecase/socket_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  // final socketUseCase = ChatSocketUseCase();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListProvider);
    final notifier = ref.read(chatListProvider.notifier);
    notifier.listenToEventsFromSocket(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: state.state == ChatListAllState.loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : state.state == ChatListAllState.fetchedAllProducts
              ? StreamBuilder(
                  stream: ref
                      .read(chatListProvider.notifier)
                      .chatsListStream
                      .stream,
                  builder: (context, snapshot) {
                    return snapshot.data == null
                        ? const Center(child: Text("No Chats Available!!"))
                        : ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              final current = snapshot.data?[index];
                              return ListTile(
                                // leading: stackedImage(current?.participants
                                //     ?.map((e) => e.avatar?.url)
                                //     .toList()),
                                title: Text("${current?.name}"),
                                subtitle: current?.isGroupChat == true &&
                                        current?.lastMessage != null
                                    ? Text(
                                        "${current?.lastMessage?.sender?.username}: ${current?.lastMessage?.content}")
                                    : Text(current?.lastMessage?.content ??
                                        "No message yet"),
                              );
                            },
                          );
                  },
                )
              : const Text("Error"),
    );
  }
  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final chatResponse = ref.watch(chatListProvider);
  //   List<Chat>? fetchedChats = chatResponse.valueOrNull?.data?.data;
  //   //chatsListStream.valueOrNull;

  //   // ? when there is new 1 on 1 chat, new group chat or user gets added in the group
  //   socketUseCase.listenToEvent(
  //     eventName: SocketEvents.newChatEvent,
  //     handler: (value) {
  //       // ? When added in group chat or new 1 on 1 chat
  //       final newChat = Chat.fromJson(value as Map<String, dynamic>);
  //       if (fetchedChats != null) {
  //         final updatedList = [newChat, ...fetchedChats];
  //         chatsListStream.sink.add(updatedList);
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //             backgroundColor: Colors.green,
  //             content: Text("New Chat Alert!!")));
  //       }
  //     },
  //   );
  //   // ? when new message is received
  //   socketUseCase.listenToEvent(
  //     eventName: SocketEvents.messageReceivedEvent,
  //     handler: (value) {
  //       final message = Message.fromJson(value as Map<String, dynamic>);
  //     },
  //   );
  //   // ? when participant gets removed from group, chat gets deleted or leaves a group
  //   socketUseCase.listenToEvent(
  //     eventName: SocketEvents.leaveChatEvent,
  //     handler: (value) {
  //       final chat = Chat.fromJson(value as Map<String, dynamic>);

  //       if (fetchedChats != null) {
  //         int index =
  //             fetchedChats.indexWhere((element) => element.id == chat.id);
  //         if (index >= 0) {
  //           fetchedChats.removeAt(index);
  //           final updatedList = [...fetchedChats];
  //           chatsListStream.sink.add(updatedList);
  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //               backgroundColor: Colors.red,
  //               content: Text("Deleted Chat Alert!!")));
  //         }
  //       }
  //     },
  //   );
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Chats ${fetchedChats?.length}"),
  //     ),
  //     body: Consumer(
  //       builder: (context, ref, child) {
  //         return chatResponse.when(
  //           data: (chatlistResponse) {
  //             final chats = chatlistResponse.data?.data;
  //             if (chatsListStream.valueOrNull == null) {
  //               chatsListStream.add(chats);
  //             }
  //             return StreamBuilder(
  //               stream: chatsListStream.stream,
  //               builder: (context, snapshot) {
  //                 return ListView.builder(
  //                   itemCount: snapshot.data?.length,
  //                   itemBuilder: (context, index) {
  //                     final current = snapshot.data?[index];
  //                     return ListTile(
  //                       // leading: stackedImage(current?.participants
  //                       //     ?.map((e) => e.avatar?.url)
  //                       //     .toList()),
  //                       title: Text("${current?.name}"),
  //                       subtitle: current?.isGroupChat == true &&
  //                               current?.lastMessage != null
  //                           ? Text(
  //                               "${current?.lastMessage?.sender?.username}: ${current?.lastMessage?.content}")
  //                           : Text(current?.lastMessage?.content ??
  //                               "No message yet"),
  //                     );
  //                   },
  //                 );
  //               },
  //             );
  //           },
  //           error: (error, stackTrace) => const Center(child: Text("Error")),
  //           loading: () => const CircularProgressIndicator.adaptive(),
  //         );
  //       },
  //     ),
  //   );
  // }
}
