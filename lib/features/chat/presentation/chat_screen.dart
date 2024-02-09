import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/shared/providers/global_providers.dart';
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
