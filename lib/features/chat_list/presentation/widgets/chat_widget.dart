import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat/presentation/chat_screen.dart';
import 'package:flutter_chat_app/features/chat_list/data/models/chat_reponse.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../chat/presentation/providers/private_chat_providers.dart';

class ChatWidgetCard extends ConsumerWidget {
  const ChatWidgetCard({
    super.key,
    required this.current,
  });

  final Chat current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(userIDProvider.notifier).state = current.id ?? "";
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                "${current.isGroupChat ?? false ? current.name : current.lastParticipantName}",
                current.id ?? "",
              ),
            ));
      },
      child: Container(
        decoration: current.isNewChat == true
            ? BoxDecoration(
                color: Colors.green[50],
                border: Border.all(width: 2, color: Colors.green),
                borderRadius: BorderRadius.circular(18))
            : null,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // leading: stackedImage(current?.participants
                  //     ?.map((e) => e.avatar?.url)
                  //     .toList()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${current.chatTitle}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        current.chatSubtitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.blueGrey,
                            fontSize: 16),
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
                      Text(
                        current.time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      current.hasNewChat
                          ? Container(
                              // height: 15,
                              // width: 15,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: Text(
                                "${current.newChatCount}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
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
        // child: ListTile(
        //   // leading: stackedImage(current?.participants
        //   //     ?.map((e) => e.avatar?.url)
        //   //     .toList()),
        //   title: Text(
        //       "${current.chatTitle}\n#${current.differenceD}"),
        //   subtitle: Text(current.chatSubtitle),
        //   trailing: current.hasNewChat
        //       ? Container(
        //           padding:
        //               const EdgeInsets.all(5),
        //           decoration: const BoxDecoration(
        //               shape: BoxShape.circle,
        //               color: Colors.green),
        //           child: Text(
        //             "${current.newChatCount}",
        //             style: const TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ))
        //       : null,
        // ),
      ),
    );
  }
}
