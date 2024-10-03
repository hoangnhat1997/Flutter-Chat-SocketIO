import 'package:flutter/material.dart';
import 'package:flutter_chat_socketio/controllers/chat_controller.dart';
import 'package:flutter_chat_socketio/controllers/sign_in_controller.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();
  final SignInController signInController = Get.put(SignInController());

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${chatController.nameUser.value}')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (chatController.messages.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }
                return ListView.builder(
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    var message = chatController.messages[index];
                    var isCurrentUser =
                        message['senderId'] == signInController.userId.value;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Colors.blue[200]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['content'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            // Text(
                            //   'From: ${message['sender']['name']}',
                            //   style: TextStyle(
                            //       fontSize: 12, color: Colors.grey[600]),
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      chatController.sendMessage(
                        signInController.userId.value,
                        chatController.userId.value,
                        messageController.text,
                      );
                      messageController.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
