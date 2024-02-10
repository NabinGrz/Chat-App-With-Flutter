import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../chat_list/data/models/message_reponse.dart';
import 'typing_indicator.dart';

class TypingWidget extends StatelessWidget {
  const TypingWidget({
    super.key,
    required this.data,
  });

  final List<Message> data;

  @override
  Widget build(BuildContext context) {
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
              imageUrl: data.first.sender?.avatar?.url == null
                  ? AppStrings.imagePlaceHolder
                  : data.first.sender?.avatar?.url ?? "",
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
