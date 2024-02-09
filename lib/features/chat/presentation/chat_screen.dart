import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/shared/providers/global_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/private_chat_providers.dart';
import 'widgets/messages_list_view_widget.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String username;
  final String id;

  const ChatScreen(this.username, this.id, {Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  get username => widget.username;
  get id => widget.id;
  Timer? _checkTypingTimer;
  startTimer() {
    _checkTypingTimer = Timer(const Duration(milliseconds: 600), () {
      ref.read(privateChatProvider.notifier).stopTyping(id);
    });
  }

  resetTimer() {
    _checkTypingTimer?.cancel();
    startTimer();
  }

  @override
  void dispose() {
    _checkTypingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(privateChatProvider);
    final messageController = TextEditingController();
    final img = ref.watch(selectedImagesProvider);
    bool showIcon = ref.watch(showIconProvider) || img != null;
    ref.read(dataProvider);
    ref.listen(privateChatProvider, (previous, next) {
      if (next.messageSend == false && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.errorMessage ?? ""),
          backgroundColor: Colors.red,
        ));
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Consumer(builder: (context, ref, child) {
        return StreamBuilder(
          stream: ref.read(privateChatProvider.notifier).streamController,
          builder: (context, snapshot) {
            return state.isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        !snapshot.hasData && snapshot.data == null
                            ? const Expanded(
                                child: Center(
                                  child: Text("No messages yet!!"),
                                ),
                              )
                            : MessagesListViewWidget(
                                data: snapshot.data!, id: id),
                        Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          decoration: img == null
                              ? null
                              : BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              if (img != null) ...{
                                SizedBox(
                                    height: 100,
                                    width: 120,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Image.file(
                                              img,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: () {
                                              ref
                                                  .read(selectedImagesProvider
                                                      .notifier)
                                                  .state = null;
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons.clear,
                                                  color: Colors.blueGrey,
                                                  size: 18,
                                                )),
                                          ),
                                        )
                                      ],
                                    ))
                              },
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                // margin: const EdgeInsets.only(bottom: 25),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.add_a_photo_outlined),
                                      onPressed: () async {
                                        final imageUseCaseNotifier =
                                            ref.read(imageUseCaseProvider);
                                        await imageUseCaseNotifier
                                            .getImageFromGallery((file) => ref
                                                .read(selectedImagesProvider
                                                    .notifier)
                                                .update((state) => file));
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
                                          ref
                                              .read(showIconProvider.notifier)
                                              .state = value != "";
                                          resetTimer();

                                          ref
                                              .read(typingProvider.notifier)
                                              .state = true;
                                          ref
                                              .read(
                                                  privateChatProvider.notifier)
                                              .startTyping(id);
                                        },
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Consumer(builder: (context, ref, child) {
                                      return !showIcon
                                          ? const SizedBox.shrink()
                                          : ref
                                                  .read(privateChatProvider
                                                      .notifier)
                                                  .isLoading
                                              ? const CircularProgressIndicator()
                                              : IconButton(
                                                  icon: const Icon(Icons.send),
                                                  onPressed: () async {
                                                    final imageData = img ==
                                                            null
                                                        ? null
                                                        : await MultipartFile
                                                            .fromFile(img.path);
                                                    final data = {
                                                      if (imageData != null)
                                                        'attachments':
                                                            imageData,
                                                      if (messageController
                                                              .text !=
                                                          "")
                                                        'content':
                                                            messageController
                                                                .text
                                                    };
                                                    final formData =
                                                        FormData.fromMap(data);
                                                    await ref
                                                        .read(
                                                            privateChatProvider
                                                                .notifier)
                                                        .sendMessage(
                                                            formData, id, false)
                                                        .then((value) =>
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus());
                                                    ref
                                                        .read(
                                                            selectedImagesProvider
                                                                .notifier)
                                                        .state = null;
                                                  },
                                                );
                                    }),
                                  ],
                                ),
                              ),
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
