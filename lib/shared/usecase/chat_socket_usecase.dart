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

  void joinChatEvent(String id) {
    socketUseCase.emit(eventName: SocketEvents.joinChatEvent, data: id);
  }

  void typingEvent(Function(String id) onTyping) {
    socketUseCase.listenToEvent(
      eventName: SocketEvents.typingEvent,
      handler: (userID) {
        final id = userID.toString();
        onTyping(id);
        print(id);
      },
    );
  }

  void stoptypingEvent(Function(String id) onStopTyping) {
    socketUseCase.listenToEvent(
      eventName: SocketEvents.stopTypingEvent,
      handler: (userID) {
        final id = userID.toString();
        onStopTyping(id);
        print(id);
      },
    );
  }

  void emitTypingEvent(String id) {
    socketUseCase.chatSocket?.emit(SocketEvents.typingEvent, id);
  }

  void emitStopTypingEvent(String id) {
    socketUseCase.chatSocket?.emit(SocketEvents.stopTypingEvent, id);
  }

  void dispose() {
    socketUseCase.dispose();
  }
}
