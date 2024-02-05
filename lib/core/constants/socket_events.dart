class SocketEvents {
  SocketEvents._();
  // ? once user is ready to go
  static const connectedEvent = "connected";
  // ? when user gets disconnected
  static const disconnectEvent = "disconnect";
  // ? when user joins a socket room
  static const joinChatEvent = "joinChat";
  // ? when participant gets removed from group; chat gets deleted or leaves a group
  static const leaveChatEvent = "leaveChat";
  // ? when admin updates a group name
  static const updateGroupNameEvent = "updateGroupName";
  // ? when new message is received
  static const messageReceivedEvent = "messageReceived";
  // ? when there is new one on one chat; new group chat or user gets added in the group
  static const newChatEvent = "newChat";
  // ? when there is an error in socket
  static const socketErrorEvent = "socketError";
  // ? when participant stops typing
  static const stopTypingEvent = "stopTyping";
  // ? when participant starts typing
  static const typingEvent = "typing";
}
