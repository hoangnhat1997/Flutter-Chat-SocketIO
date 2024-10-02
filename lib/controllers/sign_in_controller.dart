import 'package:flutter/material.dart';
import 'package:flutter_chat_socketio/screens/contact_list_screen.dart';
import 'package:get/get.dart';
import 'dart:math';

class SignInController extends GetxController {
  var userId = 0.obs;
  var name = ''.obs;
  var email = ''.obs;

  void signIn(String nameInput, String emailInput) {
    name.value = nameInput;
    email.value = emailInput;
    userId.value = Random().nextInt(10000); // Generate random user ID
    Get.to(ContactListScreen());
  }
}
