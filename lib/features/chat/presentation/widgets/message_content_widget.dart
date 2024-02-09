import 'package:flutter/material.dart';
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
      margin: EdgeInsets.only(
        top: 10,
        bottom: index == data.length - 1 ? 10 : 0,
        left: isMyMessage ? 60 : 0,
        right: !isMyMessage ? 60 : 0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: isMyMessage
          ? BoxDecoration(
              color: Colors.green,
              borderRadius: index != data.length - 1
                  ? BorderRadius.circular(10)
                  : const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ))
          : BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10),
            ),
      child: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
