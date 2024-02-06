import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_list/presentation/providers/chat_list_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListProvider);
    final notifier = ref.read(chatListProvider.notifier);

    // notifier.listenToEventsFromSocket(context);
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
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 6,
                              );
                            },
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final current = snapshot.data?[index];
                              return Container(
                                decoration: current?.isNewChat == true
                                    ? BoxDecoration(
                                        color: Colors.green[50],
                                        border: Border.all(
                                            width: 2, color: Colors.green),
                                        borderRadius: BorderRadius.circular(18))
                                    : null,
                                child: ListTile(
                                  // leading: stackedImage(current?.participants
                                  //     ?.map((e) => e.avatar?.url)
                                  //     .toList()),
                                  title: current?.isGroupChat == true
                                      ? Text("${current?.name}")
                                      : Text(
                                          "${current?.participants?.last.username}"),
                                  subtitle: current?.isGroupChat == true &&
                                          current?.lastMessage != null
                                      ? Text(
                                          "${current?.lastMessage?.sender?.username}: ${current?.lastMessage?.content}")
                                      : Text(current?.lastMessage?.content ??
                                          "No message yet"),
                                  trailing: current?.newChatCount != null &&
                                          current!.newChatCount > 0
                                      ? Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green),
                                          child: Text(
                                            "${current.newChatCount}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))
                                      : null,
                                ),
                              );
                            },
                          );
                  },
                )
              : const Text("Error"),
    );
  }
}
