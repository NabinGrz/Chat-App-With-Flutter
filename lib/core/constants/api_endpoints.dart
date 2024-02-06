class Endpoints {
  Endpoints._();
  static const baseUrl = "http://192.168.1.85:8080/api/v1";
  static const loginUrl = "$baseUrl/users/login";
  static const registerUrl = "$baseUrl/users/register";
  static const chatsUrl = "$baseUrl/chat-app/chats";
  static const chatUsersUrl = "$baseUrl/chat-app/chats/users";
}
