import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/app_colors.dart';
import 'package:flutter_chat_app/core/constants/app_text_style.dart';
import 'package:flutter_chat_app/features/chat_list/presentation/providers/chat_providers.dart';
import 'package:flutter_chat_app/features/chat_list/presentation/widgets/create_chat_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/string_constants.dart';
import 'widgets/chat_widget.dart';

class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // toolbarHeight: 70,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Chat",
          style: AppTextStyle.semiBold(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          Card(
            color: const Color(0xfff4f7fa),
            elevation: 0,
            child: IconButton(
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return CreateChatDialog();
                    },
                  );
                },
                icon: const Icon(
                  Icons.add_box_outlined,
                  color: AppColors.iconColor,
                )),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : state.isDataLoaded
              ? StreamBuilder(
                  stream: ref
                      .read(chatListProvider.notifier)
                      .chatsListStream
                      .stream,
                  builder: (context, snapshot) {
                    return (snapshot.data == null ||
                            (snapshot.data?.isEmpty ?? true))
                        ? Center(
                            child: Text(
                            AppStrings.noChatsAvailable,
                            style: AppTextStyle.light(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ))
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: const Color(0xfff7f6f8),
                                      filled: true,
                                      prefixIcon: const Icon(
                                        CupertinoIcons.search,
                                        color: Color(0xff969698),
                                      ),
                                      hintStyle: AppTextStyle.extraLight(),
                                      hintText: "Search Chat...",
                                      enabledBorder: const OutlineInputBorder(
                                        gapPadding: 0,
                                        borderSide: BorderSide(
                                          color: Color(0xfff7f6f8),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        gapPadding: 0,
                                        borderSide: BorderSide(
                                          color: Color(0xfff7f6f8),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      // border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 16,
                                    );
                                  },
                                  itemCount: snapshot.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final current = snapshot.data?[index];
                                    return current != null
                                        ? ChatWidgetCard(current: current)
                                        : Center(
                                            child: Text(
                                              AppStrings.noMessageYet,
                                              style: AppTextStyle.light(
                                                fontSize: 20,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          );
                  },
                )
              : const Text("Error"),
    );
  }
}
