import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/chat_providers.dart';

List<String> testList = ["nabin", "subin", "gurung", "sumita"];

class CreateChatDialog extends ConsumerWidget {
  CreateChatDialog({super.key});
  final isGroupChat = ValueNotifier(false);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createChatProvider);
    final notifier = ref.read(createChatProvider.notifier);
    final chatListNotifier = ref.read(chatListProvider.notifier);
    return Consumer(builder: (context, ref, child) {
      return PopScope(
        canPop: false,
        child: AlertDialog.adaptive(
          title: const Text("Create chat"),
          content: state.isCreating
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: isGroupChat,
                          builder: (context, value, child) {
                            return Switch.adaptive(
                                value: value,
                                onChanged: (value) =>
                                    isGroupChat.value = value);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Is it a group chat?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      child: TypeAheadField<String>(
                        suggestionsCallback: (search) async {
                          return testList
                              .where((element) =>
                                  element.contains(search) && search.isNotEmpty)
                              .toList();
                        },
                        builder: (context, controller, focusNode) {
                          return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              autofocus: false,
                              decoration: const InputDecoration(
                                hintText: "Select a user to chat....",
                                border: OutlineInputBorder(),
                                // labelText: 'User',
                              ));
                        },
                        itemBuilder: (context, test) {
                          return ListTile(
                            title: Text(test),
                          );
                        },
                        hideOnEmpty: true,
                        onSelected: (name) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    )
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () async {
                await notifier.createChat();
                await chatListNotifier
                    .getAllChatList()
                    .then((_) => chatListNotifier.addChatList());
                Navigator.pop(context);
              },
              child: const Text("Create"),
            ),
          ],
        ),
      );
    });
  }
}
