import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_list/presentation/providers/chat_list_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListProvider);
    final notifier = ref.read(chatListProvider.notifier);

    notifier.listenToEventsFromSocket(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
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
}
