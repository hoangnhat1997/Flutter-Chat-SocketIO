import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactController extends GetxController {
  var contacts = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  void fetchContacts() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('http://localhost:3000/users'));
      if (response.statusCode == 200) {
        contacts.value = json.decode(response.body);
      }
    } finally {
      isLoading(false);
    }
  }
}
