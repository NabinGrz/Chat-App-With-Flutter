import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat_list/presentation/providers/user_providers.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
          autofocus: false,
          decoration: const InputDecoration(
            hintText: "Select a user to chat....",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            ref.read(userNameProvider.notifier).state = value;
          },
        );
      },
      itemBuilder: (context, name) {
        return ListTile(
          title: Text(name?.username ?? ""),
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
