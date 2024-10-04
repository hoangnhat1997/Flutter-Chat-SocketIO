import 'dart:convert';

import 'package:flutter_chat_socketio/screens/contact_list_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignInController extends GetxController {
  var userId = 0.obs;
  var name = ''.obs;
  var email = ''.obs;
  var isLoading = false.obs;

  void signIn(String emailInput) async {
    email.value = emailInput;

    try {
      isLoading(true);
      var response = await http
          .post(Uri.parse('http://192.168.2.31:3000/users/login'), body: {
        'email': email.value,
      });
      if (response.statusCode == 201) {
        userId.value = json.decode(response.body)['id'];
        print(userId.value);
        Get.to(() => ContactListScreen());
        print(123);
      }
    } finally {
      isLoading(false);
    }
  }
}
