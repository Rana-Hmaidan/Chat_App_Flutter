import 'package:chat_app/features/chat/manager/chat_cubit/chat_cubit.dart';
import 'package:chat_app/features/chat/views/widgets/empty_widget.dart';
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

    return BlocConsumer<ChatCubit, ChatState>(
          bloc: cubit,
          listenWhen: (previous, current) => current is MessageSent,
          listener: (context, state) {
            if (state is MessageSent) {
              _messageController.clear();
            }
          },
          buildWhen: (previous, current) => current is PrivateChatLoading || current is PrivateChatSuccess,
          builder: (context, state) {

            if(state is PrivateChatLoading){
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is PrivateChatSuccess) {

              final messages = state.messages;
              final selectedUser = state.selectedUser;
              final currentUser = state.currentUser;

              debugPrint(selectedUser.username);

          return SafeArea(
            child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  const SizedBox(width: 8,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(selectedUser.photoUrl),
                      radius: 25,
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Text(
                    selectedUser.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              ),
            ),
            body: Column(
              children: [
                messages.isEmpty ? 
                const Expanded(
                child: EmptyWidget(
                    icon: Icons.waving_hand,
                    text: 'Say Hello!'),
                ):
                Expanded(
                  child: Align(
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
                                        radius: 25,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                bottomLeft: Radius.circular(30),
                                                topLeft: Radius.circular(30),
                                              ),
                                              color: Colors.deepPurpleAccent[100],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0 ,vertical: 8.0),
                                              child: Text(
                                                message.message,
                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textDirection: TextDirection.ltr,
                                              ),
                                            )
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                             message.time.toIso8601String(),
                                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                color: Colors.grey,
                                              ),
                                          ), 
                                        ],
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          'You',
                                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                )
                                : ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(message.recieverPhoto),
                                      radius: 25,
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius:const BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                bottomRight: Radius.circular(30),
                                                topLeft: Radius.circular(30),
                                              ),
                                              color: Colors.lightBlueAccent[100],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0 ,vertical: 8.0),
                                              child: Text(
                                                message.message,
                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textDirection: TextDirection.ltr,
                                              ),
                                            ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                            message.time.toIso8601String(),
                                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                color: Colors.grey,
                                              ),
                                        ),
                                      ],
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        message.recieverName,
                                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                            },
                          ),
                  
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
            ),
                    ),
          );
          }
            return const SizedBox();
          }
      
    );
    
  }
}