import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MessageImageCard extends StatelessWidget {
  final String imageUrl;
  final bool isMyMessage;
  const MessageImageCard(
      {super.key, required this.imageUrl, required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: EdgeInsets.only(
        top: 10,
        left: isMyMessage ? 60 : 0,
        right: !isMyMessage ? 60 : 0,
      ),
      decoration: const BoxDecoration(),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) {
              return Image.asset("assets/images/image_error.jpeg");
            },
            errorWidget: (context, url, error) {
              return Image.asset("assets/images/image_error.jpeg");
            },
          )),
    );
  }
}
