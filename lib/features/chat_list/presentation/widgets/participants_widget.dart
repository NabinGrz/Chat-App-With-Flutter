import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/app_text_style.dart';
import 'package:flutter_chat_app/features/chat_list/presentation/providers/user_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/user_model.dart';

class ParticipantsWidget extends StatelessWidget {
  const ParticipantsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Wrap(
            children: List.generate(
                ref.watch(participantsProvider)?.length ?? 0, (index) {
          final user = ref.watch(participantsProvider)?[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Chip(
                label: Text(
                  "${user?.username}",
                  style: AppTextStyle.regular(fontSize: 12),
                ),
                deleteIcon: const Icon(Icons.clear),
                onDeleted: () {
                  int? index = ref
                          .watch(participantsProvider)
                          ?.indexWhere((element) => element.id == user?.id) ??
                      0;
                  Datum? current = ref.watch(participantsProvider)?[index];
                  if (index >= 0) {
                    ref.read(participantsProvider.notifier).state = [
                      ...ref
                              .watch(participantsProvider)
                              ?.where((element) => element.id != current?.id) ??
                          [],
                    ];
                  }
                },
              ),
              const SizedBox(
                width: 2,
              ),
            ],
          );
        }));
      },
    );
  }
}
