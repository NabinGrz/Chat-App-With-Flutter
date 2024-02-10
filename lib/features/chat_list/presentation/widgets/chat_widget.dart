import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/app_colors.dart';
import 'package:flutter_chat_app/core/constants/app_text_style.dart';
import 'package:flutter_chat_app/features/chat/presentation/chat_screen.dart';
import 'package:flutter_chat_app/features/chat_list/data/models/chat_reponse.dart';
import 'package:flutter_chat_app/shared/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../chat/presentation/providers/private_chat_providers.dart';
import 'stacked_image.dart';

class ChatWidgetCard extends ConsumerWidget {
  const ChatWidgetCard({
    super.key,
    required this.current,
  });

  final Chat current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        ref.read(userIDProvider.notifier).state = current.id ?? "";
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                current,
              ),
            ));
      },
      child: Container(
        // decoration: current.isNewChat == true
        //     ? BoxDecoration(
        //         color: Colors.green[50],
        //         border: Border.all(width: 2, color: Colors.green),
        //         borderRadius: BorderRadius.circular(18))
        //     : null,
        // margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  stackedImage(
                      current.participants?.map((e) => e.avatar?.url).toList(),
                      52),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${current.chatTitle?.capitialize}",
                        style: AppTextStyle.semiBold(
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (current.hasAttachment) ...{
                            const RotationTransition(
                              turns: AlwaysStoppedAnimation(60 / 360),
                              child: Icon(
                                Icons.attach_file_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                            )
                          },
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            child: Text(current.chatSubtitle,
                                style: AppTextStyle.regular(
                                    fontSize: 14,
                                    color: current.isNewChat == true
                                        ? null
                                        : Colors.grey)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(current.time, style: AppTextStyle.regular()),
                      current.hasNewChat
                          ? Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "${current.newChatCount}",
                                  style: AppTextStyle.regular(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          : const SizedBox.shrink(),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
