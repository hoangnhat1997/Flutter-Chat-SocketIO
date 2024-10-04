import 'package:flutter/material.dart';
import 'package:flutter_chat_socketio/controllers/contact_controller.dart';
import 'package:get/get.dart';

class ContactListScreen extends StatelessWidget {
  final ContactController contactController = Get.put(ContactController());

  ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: SafeArea(
        child: Obx(() {
          if (contactController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: contactController.contacts.length,
            itemBuilder: (context, index) {
              var contact = contactController.contacts[index];
              return ListTile(
                leading: const Icon(Icons.person, size: 40),
                title: Text(contact['name']),
                onTap: () {
                  Get.toNamed('/chat/${contact['id']}');
                },
              );
            },
          );
        }),
      ),
    );
  }
}
