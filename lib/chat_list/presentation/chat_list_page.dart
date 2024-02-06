import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_list/presentation/providers/chat_providers.dart';
import 'package:flutter_chat_app/chat_list/presentation/widgets/create_chat_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/chat_widget.dart';

class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
              onPressed: () {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return CreateChatDialog();
                  },
                );
              },
              icon: const Icon(Icons.add_box_outlined))
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : state.isDataLoaded
              ? StreamBuilder(
                  stream: ref
                      .read(chatListProvider.notifier)
                      .chatsListStream
                      .stream,
                  builder: (context, snapshot) {
                    return snapshot.data == null
                        ? const Center(child: Text("No Chats Available!!"))
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 16,
                              );
                            },
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final current = snapshot.data?[index];
                              return current != null
                                  ? ChatWidgetCard(current: current)
                                  : const Center(
                                      child: Text("No messages yet!!"),
                                    );
                            },
                          );
                  },
                )
              : const Text("Error"),
    );
  }
}
