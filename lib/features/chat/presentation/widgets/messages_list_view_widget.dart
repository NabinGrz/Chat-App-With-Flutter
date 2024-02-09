import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat/presentation/widgets/message_content_widget.dart';
import 'package:flutter_chat_app/features/chat/presentation/widgets/message_image_card.dart';
import 'package:flutter_chat_app/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../chat_list/data/models/message_reponse.dart';
import '../providers/private_chat_providers.dart';

class MessagesListViewWidget extends ConsumerWidget {
  final List<Message> data;
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
        reverse: true,
        controller: controller,
        children: [
          if (ref.read(privateChatProvider.notifier).isTyping) ...{
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundImage: data.first.sender?.avatar?.url == null
                        ? const NetworkImage(
                            "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png")
                        : NetworkImage(data.first.sender?.avatar?.url ?? ""),
                  ),
                ),
                // const SizedBox(width: 6),
                const Expanded(
                  child: TypingIndicator(
                    circleHeight: 10,
                    circleWidth: 10,
                    indicatorHeight: 30,
                    indicatorWidth: 60,
                    showIndicator: true,
                    bubbleColor: Color.fromARGB(255, 174, 177, 178),
                    flashingCircleBrightColor: Color(0xFF333333),
                    flashingCircleDarkColor: Color(0xFFaec1dd),
                  ),
                ),
              ],
            )
          },
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final message = data[index];
              bool isMyMessage =
                  ref.watch(myUserIDProvider) == message.sender?.id;
              return Align(
                alignment:
                    isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                child: Row(
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
                          color: Colors.orange,
                        ),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: message.sender?.avatar?.url == null
                              ? const NetworkImage(
                                  "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png")
                              : NetworkImage(message.sender?.avatar?.url ?? ""),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MessageImageCard(
                                  imageUrl: "${message.attachments?.first.url}",
                                  isMyMessage: isMyMessage,
                                ),
                                MessageContentCard(
                                    index: index,
                                    data: data,
                                    content: "${message.content}",
                                    isMyMessage: isMyMessage),
                              ],
                            )
                          : message.attachments != null &&
                                  message.attachments!.isNotEmpty
                              ? MessageImageCard(
                                  isMyMessage: isMyMessage,
                                  imageUrl: "${message.attachments?.first.url}")
                              : MessageContentCard(
                                  index: index,
                                  data: data,
                                  content: "${message.content}",
                                  isMyMessage: isMyMessage),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
