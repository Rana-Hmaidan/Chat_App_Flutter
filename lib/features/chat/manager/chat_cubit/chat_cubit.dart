import 'package:chat_app/core/models/user_data.dart';
//import 'package:chat_app/core/services/firestore_services.dart';
import 'package:chat_app/core/services/user_services.dart';
import 'package:chat_app/features/chat/services/chat_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/features/chat/models/chat_message.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final chatServices = ChatServices();
  final userServices = UserServices();

  Future<void> sendMessage(String message) async {
    emit(SendingMessage());
    try {
      final currentUser = await userServices.getUser();

      final chatMessage = ChatMessage(
        id: DateTime.now().toIso8601String(),
        message: message,
        senderId: currentUser.id,
        senderName: currentUser.username,
        senderPhoto: currentUser.photoUrl,
        recieverId: '',
        recieverName: '',
        recieverPhoto: '',
        time: DateTime.now(),
      );

      await chatServices.sendMessage(chatMessage);
      emit(MessageSent());
    } catch (e) {
      emit(SendingError(e.toString()));
    }
  }

    Future<void> getMessages() async {
    emit(ChatLoading());
    try {
      final currentUser = await userServices.getUser();

      final messagesStream = chatServices.getMessages();

      messagesStream.listen((messages) {
        emit(ChatSuccess(messages, currentUser.id));
      });
      
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendChatMessage(String message, UserData selectedUser) async {
    emit(SendingMessage());
    try {
      final currentUser = await userServices.getUser();

      final chatMessage = ChatMessage(
        id: DateTime.now().toIso8601String(),
        message: message,
        senderId: currentUser.id,
        senderName: currentUser.username,
        senderPhoto: currentUser.photoUrl,
        recieverId: selectedUser.id,
        recieverName: selectedUser.username,
        recieverPhoto: selectedUser.photoUrl,
        time: DateTime.now(),
      );

      await chatServices.sendChatMessage(chatMessage, currentUser.id , selectedUser.id);
      emit(MessageSent());
    } catch (e) {
      emit(SendingError(e.toString()));
    }
  }

  Future<void> getChatMessages(UserData user) async {
    debugPrint(user.username);
    emit(PrivateChatLoading());
    try {
      final currentUser = await userServices.getUser();
      final selectedUser = await userServices.getSelectedUser(user.id);

      final messagesStream = chatServices.getChatMessages(currentUser.id, selectedUser.id);

      debugPrint(user.username);
      debugPrint(selectedUser.username);
      debugPrint(currentUser.username);

      // messagesStream.listen((messages) {
      //   emit(PrivateChatSuccess(messages, selectedUser , currentUser));
      // });
      if(await messagesStream.isEmpty){
        emit(PrivateChatSuccess([], selectedUser , currentUser));
      }
      else{
      messagesStream.listen((messages) {
        emit(PrivateChatSuccess(messages, selectedUser , currentUser));
      });
      }
      
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  // Future<void> getUserDetails(UserData user) async {
  //   emit(ChatLoading());
  //   try {
  //     final currentUser = await userServices.getUser();
  //     final selectedUser = await userServices.getSelectedUser(user.id);
  //     emit(PrivateChatLoaded(selectedUser, currentUser));
  //   } catch (e) {
  //     emit(ChatError(e.toString()));
  //   }
  // }

  
}