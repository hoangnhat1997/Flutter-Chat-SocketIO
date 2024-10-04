import 'package:flutter_chat_socketio/controllers/sign_in_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactController extends GetxController {
  var contacts = <dynamic>[].obs;
  var isLoading = true.obs;
  final SignInController signInController = Get.put(SignInController());

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  void fetchContacts() async {
    try {
      isLoading(true);
      var response =
          await http.get(Uri.parse('${dotenv.env['API_URL']}/users'));
      if (response.statusCode == 200) {
        contacts.value = json
            .decode(response.body)
            .where((contact) => contact['id'] != signInController.userId.value)
            .toList();
      }
    } finally {
      isLoading(false);
    }
  }
}
