class ApiPath {

  static String user(String uId) => 'users/$uId';
  static String users() => 'users/';

  static String sendMessage(String id) => 'messages/$id';
  static String messages() => 'messages/';

  static String sendChatMessage(String uId, String selectedId ) => 'users/$uId/chat/$selectedId/messages/';
  static String getChatMessages(String uId, String selectedId) => 'users/$uId/chat/$selectedId/messages/';
}