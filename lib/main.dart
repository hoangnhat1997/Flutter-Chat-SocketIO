import 'package:flutter/material.dart';
import 'package:flutter_chat_socketio/screens/chat_screen.dart';
import 'package:flutter_chat_socketio/screens/contact_list_screen.dart';
import 'package:flutter_chat_socketio/screens/sign_in_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      initialRoute: '/sign-in',
      getPages: [
        GetPage(name: '/sign-in', page: () => SignInScreen()),
        GetPage(name: '/contacts', page: () => ContactListScreen()),
        GetPage(name: '/chat/:userId', page: () => ChatScreen()),
      ],
    );
  }
}
