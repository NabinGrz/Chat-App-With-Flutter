import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/app_colors.dart';
import 'package:flutter_chat_app/core/constants/app_text_style.dart';
import 'package:flutter_chat_app/features/chat_list/data/models/message_reponse.dart';

class MessageContentCard extends StatelessWidget {
  final int index;
  final List<Message> data;
  final String content;
  final String senderID;
  final String myID;
  final bool isMyMessage;
  const MessageContentCard(
      {super.key,
      required this.index,
      required this.data,
      required this.content,
      required this.isMyMessage,
      required this.senderID,
      required this.myID});

  @override
  Widget build(BuildContext context) {
    String? beforeMe = (index - 1) < 0 ? "*" : data[index - 1].sender?.id;
    String? afterMe =
        (index + 1) >= data.length ? "#" : data[index + 1].sender?.id;
    String me = senderID;
    bool isLastMessage = afterMe != me;
    bool isFirstMessage = beforeMe != me && me == afterMe;
    return Container(
      margin: EdgeInsets.only(
        left: isMyMessage ? 60 : 0,
        right: !isMyMessage ? 60 : 0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: isMyMessage
          ? BoxDecoration(
              color: AppColors.primary,
              borderRadius: index != data.length - 1
                  ? BorderRadius.circular(30)
                  : const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
            )
          : BoxDecoration(
              color: const Color(0xffe9e8e8),
              borderRadius: beforeMe != me && afterMe != me
                  ? BorderRadius.circular(10)
                  : isLastMessage
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                          bottomLeft: Radius.circular(20),
                        )
                      : isFirstMessage
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          : BorderRadius.circular(10),
            ),
      child: Text(
        content,
        // "$content:$isLastMessage:$isFirstMessage: ${data.length >= 2}",
        style: AppTextStyle.light(
          color: isMyMessage ? Colors.white : const Color(0xff1f1f1f),
          fontSize: 16,
        ),
      ),
    );
  }
}
