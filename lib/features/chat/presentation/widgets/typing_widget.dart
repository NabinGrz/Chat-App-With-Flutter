import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../chat_list/data/models/chat_list_response.dart';
import '../../../chat_list/data/models/message_reponse.dart';
import 'typing_indicator.dart';
import 'package:collection/collection.dart';

class TypingWidget extends StatelessWidget {
  const TypingWidget({
    super.key,
    required this.data,
    this.id,
  });

  final List<Message> data;
  final String? id;

  @override
  Widget build(BuildContext context) {
    Message? message = data.firstWhereOrNull((element) => element.id == id);
    bool hasNoMessage = message == null;
    String? url = message?.sender?.avatar?.url;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CachedNetworkImage(
              height: 24,
              width: 24,
              fit: BoxFit.cover,
              imageUrl: hasNoMessage ? AppStrings.imagePlaceHolder : url ?? "",
              placeholder: (context, url) =>
                  Image.asset("assets/images/image_error.jpeg"),
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
            )),
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
    );
  }
}
