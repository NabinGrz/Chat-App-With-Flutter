import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/app_colors.dart';
import 'package:flutter_chat_app/core/constants/app_text_style.dart';
import 'package:flutter_chat_app/features/chat_list/data/models/message_reponse.dart';

class MessageContentCard extends StatelessWidget {
  final int index;
  final List<Message> data;
  final String content;
  final bool isMyMessage;
  const MessageContentCard(
      {super.key,
      required this.index,
      required this.data,
      required this.content,
      required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      margin: EdgeInsets.only(
        // bottom: index == data.length - 1 ? 10 : 0,
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
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ))
          : BoxDecoration(
              color: const Color(0xffe9e8e8),
              borderRadius: BorderRadius.circular(10),
            ),
      child: Text(content,
          style: AppTextStyle.light(
            color: isMyMessage ? Colors.white : Colors.black,
            fontSize: 16,
          )),
    );
  }
}
