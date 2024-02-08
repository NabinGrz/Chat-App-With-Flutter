import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat_list/domain/entities/group_data_model.dart';
import 'package:flutter_chat_app/features/chat_list/presentation/providers/user_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/user_model.dart';
import '../providers/chat_providers.dart';
import '../providers/create_chat_providers.dart';
import 'participants_widget.dart';
import 'user_text_field.dart';

class CreateChatDialog extends ConsumerWidget {
  CreateChatDialog({super.key});
  final isGroupChatNotifier = ValueNotifier(false);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createChatProvider);
    final notifier = ref.read(createChatProvider.notifier);
    final chatListNotifier = ref.read(chatListProvider.notifier);
    final userController = TextEditingController();
    // final groupNameController = TextEditingController();
    final userState = ref.watch(userProvider);
    final isGroupChat = ref.watch(isGroupChatProvider);

    Future<void> reset() async {
      notifier.reset();
      await chatListNotifier
          .getAllChatList()
          .then((_) => chatListNotifier.addChatList())
          .then((value) => Navigator.pop(context));
      ref.read(userIdProvider.notifier).state = null;
      ref.read(userNameProvider.notifier).state = null;
      ref.read(groupNameProvider.notifier).state = null;
      ref.read(participantsProvider.notifier).state = [];
      userController.clear();
    }

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
                                  ref.read(groupNameProvider.notifier).state =
                                      null;
                                  ref.read(userNameProvider.notifier).state =
                                      null;
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
                        decoration: const InputDecoration(
                          hintText: "Enter a group name...",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          ref.read(groupNameProvider.notifier).state = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    },
                    userState.when(
                        data: (data) {
                          List<Datum?>? nameList = data.data;
                          return nameList != null
                              ? UserTextField(
                                  nameList: nameList,
                                  userController: userController,
                                  isGroupChat: isGroupChat)
                              : const Text("No users");
                        },
                        error: (_, __) => const Text("error"),
                        loading: () => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )),
                    if (ref.watch(isGroupChatProvider)) ...{
                      const ParticipantsWidget()
                    },
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
        ),
        actions: dialogActions(context, ref, userController, notifier, reset),
      ),
    );
  }

  List<Widget> dialogActions(
      BuildContext context,
      WidgetRef ref,
      TextEditingController userController,
      CreateChatNotifier notifier,
      Future<void> Function() reset) {
    return [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          ref.read(userIdProvider.notifier).state = null;
          ref.read(userNameProvider.notifier).state = null;
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
                  name: ref.watch(groupNameProvider) ?? "",
                  participants: selectedParticipants));
              await reset();
            }
          } else {
            if (selectedID != null) {
              await notifier.createChat(selectedID);
              await reset();
            }
          }
        },
        child: const Text("Create"),
      ),
    ];
  }
}
