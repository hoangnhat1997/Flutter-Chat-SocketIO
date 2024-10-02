import 'package:flutter/material.dart';
import 'package:flutter_chat_socketio/controllers/sign_in_controller.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  final SignInController signInController = Get.put(SignInController());
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField(
            //   controller: nameController,
            //   decoration: const InputDecoration(labelText: 'Name'),
            // ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signInController.signIn(emailController.text);
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
