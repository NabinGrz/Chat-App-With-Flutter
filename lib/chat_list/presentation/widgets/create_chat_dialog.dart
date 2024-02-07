import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_list/domain/entities/group_data_model.dart';
import 'package:flutter_chat_app/chat_list/presentation/providers/user_providers.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/user_model.dart';
import '../providers/chat_providers.dart';
import '../providers/create_chat_providers.dart';

// List<String> testList = ["nabin", "subin", "gurung", "sumita"];

class CreateChatDialog extends ConsumerWidget {
  CreateChatDialog({super.key});
  final isGroupChatNotifier = ValueNotifier(false);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createChatProvider);
    final notifier = ref.read(createChatProvider.notifier);
    final chatListNotifier = ref.read(chatListProvider.notifier);
    final userController = TextEditingController();
    final groupNameController = TextEditingController();
    final userState = ref.watch(userProvider);
    // final isGroupChat = ref.watch(isGroupChatProvider);
    // final participants = ref.watch(participantsProvider);
    return PopScope(
      canPop: false,
      child: AlertDialog.adaptive(
        title: const Text("Create chat"),
        content: Material(
          color: Colors.transparent,
          child: state.isCreating
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: isGroupChatNotifier,
                          builder: (context, value, child) {
                            return Switch.adaptive(
                                value: value,
                                onChanged: (value) {
                                  isGroupChatNotifier.value = value;
                                  ref.read(isGroupChatProvider.notifier).state =
                                      value;
                                  ref.read(userIdProvider.notifier).state =
                                      null;
                                  ref
                                      .read(participantsProvider.notifier)
                                      .state = [];
                                  userController.clear();
                                  groupNameController.clear();
                                });
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
                    if (ref.watch(isGroupChatProvider)) ...{
                      TextField(
                          controller: groupNameController,
                          decoration: const InputDecoration(
                            hintText: "Enter a group name...",
                            border: OutlineInputBorder(),
                            // labelText: 'User',
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                    },
                    userState.when(
                        data: (data) {
                          List<Datum?>? nameList = data.data;
                          return nameList != null
                              ? TypeAheadField<Datum?>(
                                  controller: userController,
                                  suggestionsCallback: (search) {
                                    return nameList
                                        .where((element) =>
                                            (element?.username
                                                    ?.toLowerCase()
                                                    .contains(
                                                        search.toLowerCase()) ??
                                                false) &&
                                            search.isNotEmpty)
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
                                        ));
                                  },
                                  itemBuilder: (context, name) {
                                    return ListTile(
                                      title: Text(name?.username ?? ""),
                                    );
                                  },
                                  hideOnEmpty: true,
                                  onSelected: (name) {
                                    // FocusScope.of(context).unfocus();
                                    if (!ref.watch(isGroupChatProvider)) {
                                      ref.read(userIdProvider.notifier).state =
                                          name?.id;
                                    } else {
                                      if (name != null) {
                                        ref
                                            .read(participantsProvider.notifier)
                                            .state = [
                                          ...ref.watch(participantsProvider) ??
                                              [],
                                          name
                                        ];
                                      }
                                    }
                                    userController.text = name?.username ?? "";
                                    groupNameController.text = "Testing";
                                  },
                                )
                              : const Text("No users");
                        },
                        error: (_, __) => const Text("error"),
                        loading: () => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )),
                    if (ref.watch(isGroupChatProvider)) ...{
                      Consumer(
                        builder: (context, ref, child) {
                          return Wrap(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                  ref.watch(participantsProvider)?.length ?? 0,
                                  (index) {
                            final user =
                                ref.watch(participantsProvider)?[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Chip(
                                  label: Text(
                                    "${user?.username}",
                                  ),
                                  deleteIcon: const Icon(Icons.clear),
                                  onDeleted: () {
                                    int? index = ref
                                            .watch(participantsProvider)
                                            ?.indexWhere((element) =>
                                                element.id == user?.id) ??
                                        0;
                                    Datum? current =
                                        ref.watch(participantsProvider)?[index];
                                    if (index >= 0) {
                                      ref
                                          .read(participantsProvider.notifier)
                                          .state = [
                                        ...ref
                                                .watch(participantsProvider)
                                                ?.where((element) =>
                                                    element.id !=
                                                    current?.id) ??
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
                      )
                    },
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(userIdProvider.notifier).state = null;
              userController.clear();
            },
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () async {
              final selectedID = ref.read(userIdProvider.notifier).state;

              if (ref.watch(isGroupChatProvider)) {
                final selectedParticipants = ref
                        .watch(participantsProvider)
                        ?.map((e) => e.id ?? "")
                        .toList() ??
                    [];
                if (selectedParticipants.isNotEmpty) {
                  await notifier.createGroupChat(GroupDataModel(
                      name: groupNameController.text,
                      participants: selectedParticipants));
                  notifier.reset();
                  await chatListNotifier
                      .getAllChatList()
                      .then((_) => chatListNotifier.addChatList());
                  Navigator.pop(context);
                  ref.read(userIdProvider.notifier).state = null;
                  userController.clear();
                  groupNameController.clear();
                  ref.read(participantsProvider.notifier).state = [];
                }
              } else {
                if (selectedID != null) {
                  await notifier.createChat(selectedID);
                  notifier.reset();
                  await chatListNotifier
                      .getAllChatList()
                      .then((_) => chatListNotifier.addChatList());
                  Navigator.pop(context);
                  ref.read(userIdProvider.notifier).state = null;
                  userController.clear();
                  groupNameController.clear();
                  ref.read(participantsProvider.notifier).state = [];
                }
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}
