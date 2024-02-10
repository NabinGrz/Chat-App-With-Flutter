import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/app_colors.dart';
import 'package:flutter_chat_app/core/constants/app_text_style.dart';
import 'package:flutter_chat_app/core/constants/string_constants.dart';
import 'package:flutter_chat_app/features/chat_list/data/models/chat_reponse.dart';
import 'package:flutter_chat_app/shared/extensions/date_time_extensions.dart';
import 'package:flutter_chat_app/shared/extensions/list_extensions.dart';
import 'package:flutter_chat_app/shared/providers/global_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../chat_list/presentation/widgets/stacked_image.dart';
import 'providers/private_chat_providers.dart';
import 'widgets/messages_list_view_widget.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Chat? current;

  const ChatScreen(this.current, {Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  Chat? get current => widget.current;
  get username =>
      "${current?.isGroupChat ?? false ? current?.name : current?.lastParticipantName}";
  get id => current?.id ?? "";
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
    final myID = ref.watch(myUserIDProvider);
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
      backgroundColor: const Color(0xfff7f6f8),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            stackedImage(
                current?.participants?.map((e) => e.avatar).toList(), 48, myID),
            Text(
              username,
              style: AppTextStyle.semiBold(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Consumer(builder: (context, ref, child) {
        return StreamBuilder(
          stream: ref.read(privateChatProvider.notifier).streamController,
          builder: (context, snapshot) {
            return state.isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Column(
                    children: [
                      !snapshot.hasData && snapshot.data == null
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  AppStrings.noMessageYet,
                                  style: AppTextStyle.light(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          : MessagesListViewWidget(
                              data: snapshot.data!.groupBy(
                                (msg) => msg.createdAt.format('yyyy-MM-dd'),
                              ),
                              id: id),
                      Container(
                        // margin: const EdgeInsets.only(
                        //     // bottom: 25,
                        //     ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: img == null
                            ? const BoxDecoration(
                                color: Colors.white,
                              )
                            : BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                              height: 6,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    // margin: const EdgeInsets.only(bottom: 25),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final imageUseCaseNotifier =
                                                ref.read(imageUseCaseProvider);
                                            await imageUseCaseNotifier
                                                .getImageFromGallery((file) => ref
                                                    .read(selectedImagesProvider
                                                        .notifier)
                                                    .update((state) => file));
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle),
                                            padding: const EdgeInsets.all(8),
                                            child: const Icon(
                                              Icons.photo_camera,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: messageController,
                                            decoration: InputDecoration(
                                              hintText: "Type a message",
                                              hintStyle:
                                                  AppTextStyle.extraLight(),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                            ),
                                            onChanged: (value) {
                                              resetTimer();
                                              ref
                                                  .read(typingProvider.notifier)
                                                  .state = true;
                                              ref
                                                  .read(privateChatProvider
                                                      .notifier)
                                                  .startTyping(id);
                                              ref
                                                  .read(
                                                      showIconProvider.notifier)
                                                  .toggle(value);
                                            },
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Consumer(builder: (context, ref, child) {
                                  return !showIcon
                                      ? const SizedBox.shrink()
                                      : ref
                                              .read(
                                                  privateChatProvider.notifier)
                                              .isLoading
                                          ? const CircularProgressIndicator()
                                          : IconButton(
                                              icon: const Icon(
                                                Icons.send,
                                                color: AppColors.primary,
                                              ),
                                              onPressed: () async {
                                                final imageData = img == null
                                                    ? null
                                                    : await MultipartFile
                                                        .fromFile(img.path);
                                                final data = {
                                                  if (imageData != null)
                                                    'attachments': imageData,
                                                  if (messageController.text !=
                                                      "")
                                                    'content':
                                                        messageController.text
                                                };
                                                final formData =
                                                    FormData.fromMap(data);
                                                await ref
                                                    .read(privateChatProvider
                                                        .notifier)
                                                    .sendMessage(
                                                        formData, id, false)
                                                    .then((value) =>
                                                        FocusScope.of(context)
                                                            .unfocus());
                                                ref
                                                    .read(selectedImagesProvider
                                                        .notifier)
                                                    .state = null;
                                              },
                                            );
                                }),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  );
          },
        );
      }),
    );
  }
}
