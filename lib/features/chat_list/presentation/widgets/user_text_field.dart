import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat_list/presentation/providers/user_providers.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../data/models/user_model.dart';

class UserTextField extends ConsumerWidget {
  const UserTextField({
    super.key,
    required this.nameList,
    required this.userController,
    required this.isGroupChat,
  });

  final List<Datum?>? nameList;
  final TextEditingController userController;
  final bool isGroupChat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TypeAheadField<Datum?>(
      suggestionsCallback: (search) {
        return nameList
            ?.where((element) => (element?.username
                    ?.toLowerCase()
                    .contains(search.toLowerCase()) ??
                false))
            .toList();
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: userController,
          focusNode: focusNode,
          style: AppTextStyle.regular(),
          autofocus: false,
          decoration: InputDecoration(
            hintText: "Select a user to chat....",
            hintStyle: AppTextStyle.extraLight(fontSize: 14),
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            ref.read(userNameProvider.notifier).state = value;
          },
        );
      },
      itemBuilder: (context, name) {
        return ListTile(
          title: Text(
            name?.username ?? "",
            style: AppTextStyle.regular(fontSize: 12),
          ),
        );
      },
      onSelected: (name) {
        if (!isGroupChat) {
          ref.read(userIdProvider.notifier).state = name?.id;
          userController.text = name?.username ?? "";
          //
        } else {
          if (name != null) {
            ref.read(participantsProvider.notifier).state = [
              ...ref.watch(participantsProvider) ?? [],
              name
            ];
            FocusScope.of(context).unfocus();
          }
        }
      },
    );
  }
}
