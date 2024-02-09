import 'package:dio/dio.dart';
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
    final messageController = TextEditingController();
    ref.read(dataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Consumer(builder: (context, ref, child) {
        return StreamBuilder(
          stream: ref.read(privateChatProvider.notifier).streamController,
          builder: (context, snapshot) {
            return state.isLoading
                //  ||
                //         snapshot.connectionState != ConnectionState.
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        !snapshot.hasData && snapshot.data == null
                            ? Expanded(
                                child: Center(
                                  child: Text(
                                      "No messages yet!! ${snapshot.connectionState}"),
                                ),
                              )
                            : MessagesListViewWidget(
                                data: snapshot.data!, id: id),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          margin: const EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_a_photo_outlined),
                                onPressed: () {
                                  // Implement send functionality
                                },
                              ),
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                    hintText: "Type a message",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  onChanged: (value) {
                                    ref.read(showIconProvider.notifier).state =
                                        value != "";
                                  },
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              // messageController.text.isEmpty
                              //     ? const SizedBox()
                              //     :
                              Consumer(builder: (context, ref, child) {
                                return !ref.watch(showIconProvider)
                                    ? const SizedBox.shrink()
                                    : ref
                                            .read(privateChatProvider.notifier)
                                            .isLoading
                                        ? const CircularProgressIndicator()
                                        : IconButton(
                                            icon: const Icon(Icons.send),
                                            onPressed: () async {
                                              final data = FormData.fromMap({
                                                'content':
                                                    messageController.text
                                              });
                                              await ref
                                                  .read(privateChatProvider
                                                      .notifier)
                                                  .sendMessage(data, id)
                                                  .then((value) =>
                                                      FocusScope.of(context)
                                                          .unfocus());
                                            },
                                          );
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
          },
        );
      }),
    );
  }
}
