import 'package:chat_app/core/utils/route/app_routes.dart';
//import 'package:chat_app/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:chat_app/features/chat/manager/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivateChatPage extends StatefulWidget {
  const PrivateChatPage({super.key});

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final _messageController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChatCubit>(context);
    //final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocConsumer<ChatCubit, ChatState>(
          bloc: cubit,
          listenWhen: (previous, current) => current is MessageSent,
          listener: (context, state) {
            if (state is MessageSent) {
              _messageController.clear();
            }
          },
          buildWhen: (previous, current) => current is PrivateChatSuccess,
          builder: (context, state) {
            if (state is PrivateChatSuccess) {

              final messages = state.messages;
              final selectedUser = state.selectedUser;
              final currentUser = state.currentUser;

            return Column(
              children: [
                Expanded(
                  child:  Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:[
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_outlined), 
                                    onPressed: (){
                                      Navigator.of(context, rootNavigator: true).popAndPushNamed(AppRoutes.home); 
                                    },
                                  ),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(selectedUser.photoUrl),
                                    radius: 30,
                                  ),
                                  const SizedBox(width: 8,),
                                  Text(
                                    selectedUser.username,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                controller: scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message = messages[index];
                                  
                                  return currentUser.id == message.senderId
                                    ? Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(message.senderPhoto),
                                          ),
                                          title: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                bottomRight: Radius.circular(30),
                                                topLeft: Radius.circular(30),
                                              ),
                                              color: Colors.deepPurpleAccent[100],
                                            ),
                                            child: Text(
                                              message.message,
                                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ),
                                          subtitle: Text(
                                            message.time.toIso8601String(),
                                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                    )
                                    : ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(message.recieverPhoto),
                                        ),
                                        title: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:const BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                bottomLeft: Radius.circular(30),
                                                topLeft: Radius.circular(30),
                                              ),
                                              color: Colors.lightBlueAccent[100],
                                            ),
                                            child: Text(
                                              message.message,
                                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                        ),
                                        //Bubble
                                        subtitle: Text(
                                          message.time.toIso8601String(),
                                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                },
                              ),
                            ),
                          ],
                  ),
                ),
                const Divider(height: 1),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: InputBorder.none,
                    hintText: 'Type a message',
                    suffixIcon: IconButton(
                      onPressed: () async =>
                          await cubit.sendChatMessage(_messageController.text, selectedUser),
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ),
              ],
            );
          }
            return const SizedBox();
          }
        ),
      ),
    );
  }
}