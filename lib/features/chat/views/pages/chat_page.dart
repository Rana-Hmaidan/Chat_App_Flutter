import 'package:chat_app/features/chat/manager/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/features/chat/views/widgets/empty_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final scrollController = ScrollController();

//   Future<void> onFieldSubmitted() async {
//   addMessage();
   
//   // Move the scroll position to the bottom
//   scrollController.animateTo(
//     0,
//     duration: const Duration(milliseconds: 300),
//     curve: Curves.easeInOut,
//   );

//   textEditingController.text = '';
//  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChatCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            const SizedBox(width: 8,),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/2352/2352167.png'),
                radius: 25,
              ),
            ),
            const SizedBox(width: 8,),
            Text(
              'Grouping Chat',
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                bloc: cubit,
                listenWhen: (previous, current) => current is MessageSent,
                listener: (context, state) {
                  if (state is MessageSent) {
                    _messageController.clear();
                  }
                },
                buildWhen: (previous, current) => current is ChatSuccess,
                builder: (context, state) {
                  if (state is ChatSuccess) {
                    final messages = state.messages;
                    final currentUserId = state.currentUserId;

                    return  messages.isEmpty? 
                    
                    const Expanded(
                      child: EmptyWidget(
                      icon: Icons.waving_hand,
                      text: 'Say Hello!'),
                    ):
                    
                    Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
      
                          return currentUserId == message.senderId
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
                                  backgroundImage: NetworkImage(message.senderPhoto),
                                  radius: 25,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    message.senderName,
                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
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
                      await cubit.sendMessage(_messageController.text),
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}