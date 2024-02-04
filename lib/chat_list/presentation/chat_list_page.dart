import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_list/data/models/chat_list_response.dart';
import 'package:flutter_chat_app/chat_list/domain/state/chat_list_state.dart';
import 'package:flutter_chat_app/chat_list/presentation/providers/chat_list_providers.dart';
import 'package:flutter_chat_app/chat_list/presentation/widgets/stacked_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/typedef/app_typedef.dart';

class ChatListPage extends ConsumerWidget {
  ChatListPage({super.key});
  final chatsListStream = StreamController<ChatListData>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chatListProvider).whenData(
      (data) {
        chatsListStream.add(data);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final chatResponse = ref.watch(chatListProvider);
          return chatResponse.when(
            data: (_) {
              return StreamBuilder(
                stream: chatsListStream.stream,
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data?.data?.data?.length,
                    itemBuilder: (context, index) {
                      final current = snapshot.data?.data?.data?[index];
                      return ListTile(
                        // leading: stackedImage(current?.participants!
                        //     .map((e) => e.avatar!.url!)
                        //     .toList()),
                        // leading: Stack(
                        //   children: current?.participants
                        //       ?.map((e) => stackedImage(e))
                        //       .toList(),
                        // ),
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
              );
            },
            error: (error, stackTrace) => const Center(child: Text("Error")),
            loading: () => const CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
  // Widget build(BuildContext context, WidgetRef ref) {
  //   ref.watch(chatListProvider.notifier).getAllChatList();
  //   final state = ref.watch(chatListProvider);
  //   // ref.listen(chatListProvider.select((value) => value), (previous, next) {
  //   //   if (next.data != null) {
  //   //     chatsListStream.add(next.data!);
  //   //   }
  //   // });
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text(
  //           "Chats",
  //         ),
  //       ),
  //       body: state.state == ChatListAllState.loading
  //           ? const CircularProgressIndicator.adaptive()
  //           : Text("${state.data}")
  //       // : StreamBuilder<ChatListData>(
  //       //     stream: chatsListStream.stream,
  //       //     builder: (context, snapshot) {
  //       //       final chatList = snapshot.data;
  //       //       return ListView.builder(
  //       //         itemCount: chatList?.data?.data?.length,
  //       //         itemBuilder: (context, index) {
  //       //           final currentItem = chatList?.data?.data?[index];
  //       //           return Text("${currentItem?.name}");
  //       //         },
  //       //       );
  //       //     }),
  //       );
  // }
}
