part of 'chat_cubit.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class PrivateChatLoading extends ChatState {}

final class MessageSent extends ChatState {}

final class SendingMessage extends ChatState {}

final class SendingError extends ChatState {
  final String message;

  SendingError(this.message);
}

final class ChatSuccess extends ChatState {
  final List<ChatMessage> messages;
  final String currentUserId;
  
  ChatSuccess(this.messages, this.currentUserId);
}

final class PrivateChatSuccess extends ChatState {
  final List<ChatMessage> messages;
  final UserData selectedUser;
  final UserData currentUser;

  PrivateChatSuccess(this.messages, this.selectedUser, this.currentUser);
}

// final class PrivateChatLoaded extends ChatState {
//   final UserData selectedUser;
//   final UserData currentUser;

//   PrivateChatLoaded(this.selectedUser, this.currentUser);
// }

final class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}