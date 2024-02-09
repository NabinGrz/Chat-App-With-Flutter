import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/private_chat_providers.dart';
import 'widgets/messages_list_view_widget.dart';

class ChatScreen extends ConsumerWidget {
  final String username;
  final String id;
  const ChatScreen(this.username, this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(privateChatProvider);
    ref.read(dataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Consumer(builder: (context, ref, child) {
        return state.isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : StreamBuilder(
                stream: ref.read(privateChatProvider.notifier).streamController,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: !snapshot.hasData && snapshot.data == null
                        ? const Center(
                            child: Text("No messages yet!!"),
                          )
                        : MessagesListViewWidget(data: snapshot.data!, id: id),
                  );
                },
              );
      }),
    );
  }
}
