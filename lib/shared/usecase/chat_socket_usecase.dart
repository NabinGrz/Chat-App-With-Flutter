import 'package:flutter_chat_app/shared/usecase/socket_usecase.dart';
import '../../core/constants/socket_events.dart';
import '../../features/chat_list/data/models/chat_reponse.dart';
import '../../features/chat_list/data/models/message_reponse.dart';

class ChatSocketUseCase {
  final SocketUseCase socketUseCase;

  ChatSocketUseCase({required this.socketUseCase});

  void newChatEvent(Function(Chat chat) onNewChat) {
    socketUseCase.listenToEvent(
        eventName: SocketEvents.newChatEvent,
        handler: (value) {
          final newChat = Chat.fromJson(value as Map<String, dynamic>);
          onNewChat(newChat);
        });
  }

  void messageReceivedEvent(Function(Message message) onReceived) {
    socketUseCase.listenToEvent(
        eventName: SocketEvents.messageReceivedEvent,
        handler: (value) {
          final newMessage = Message.fromJson(value as Map<String, dynamic>);
          onReceived(newMessage);
        });
  }

  void leaveChatEvent(Function(Chat chat) onLeave) {
    socketUseCase.listenToEvent(
      eventName: SocketEvents.leaveChatEvent,
      handler: (value) {
        final chat = Chat.fromJson(value as Map<String, dynamic>);
        onLeave(chat);
      },
    );
  }

  void dispose() {
    socketUseCase.dispose();
  }
}
