import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/app_text_style.dart';
import 'package:flutter_chat_app/features/chat/presentation/widgets/message_content_widget.dart';
import 'package:flutter_chat_app/features/chat/presentation/widgets/message_image_card.dart';
import 'package:flutter_chat_app/shared/extensions/date_time_extensions.dart';
import 'package:flutter_chat_app/shared/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../chat_list/data/models/message_reponse.dart';
import '../providers/private_chat_providers.dart';

class MessagesListViewWidget extends ConsumerWidget {
  final Map<String, List<Message>> data;
  final String id;
  const MessagesListViewWidget({
    super.key,
    required this.data,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController controller = ScrollController();
    return Expanded(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        reverse: true,
        controller: controller,
        children: [
          // if (ref.read(privateChatProvider.notifier).isTyping) ...{
          //   TypingWidget(data: data)
          // },
          const SizedBox(
            height: 10,
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 12,
              );
            },
            itemCount: data.length,
            itemBuilder: (context, index) {
              final group = data.keys.elementAt(index);
              final list = data[group];
              return Column(
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      group.toDate.format("MMMM dd, yyyy"),
                      style: AppTextStyle.light(
                        color: Colors.grey,
                      ),
                    ),
                  )),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list != null ? list.length : 0,
                    itemBuilder: (context, index) {
                      final message = list![index];
                      bool isMyMessage =
                          ref.watch(myUserIDProvider) == message.sender?.id;
                      return Column(
                        crossAxisAlignment: !isMyMessage
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: isMyMessage
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isMyMessage) ...{
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        message.sender?.avatar?.url == null
                                            ? AppStrings.imagePlaceHolder
                                            : message.sender?.avatar?.url ?? "",
                                    placeholder: (context, url) => Image.asset(
                                        "assets/images/image_error.jpeg"),
                                    imageBuilder: (context, provider) {
                                      return Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: provider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                )
                              },
                              Flexible(
                                flex: 1,
                                child: ((message.attachments != null &&
                                            message.attachments!.isNotEmpty) &&
                                        (message.content != null &&
                                            message.content != ""))
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          MessageImageCard(
                                            imageUrl:
                                                "${message.attachments?.first.url}",
                                            isMyMessage: isMyMessage,
                                          ),
                                          MessageContentCard(
                                              myID: ref.watch(myUserIDProvider),
                                              senderID:
                                                  message.sender?.id ?? "",
                                              index: index,
                                              data: list,
                                              content: "${message.content}",
                                              isMyMessage: isMyMessage),
                                        ],
                                      )
                                    : message.attachments != null &&
                                            message.attachments!.isNotEmpty
                                        ? MessageImageCard(
                                            isMyMessage: isMyMessage,
                                            imageUrl:
                                                "${message.attachments?.first.url}")
                                        : MessageContentCard(
                                            myID: ref.watch(myUserIDProvider),
                                            senderID: message.sender?.id ?? "",
                                            index: index,
                                            data: list,
                                            content: "${message.content}",
                                            isMyMessage: isMyMessage),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
