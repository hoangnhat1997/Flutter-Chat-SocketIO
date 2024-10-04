import 'package:flutter/foundation.dart';
import 'package:flutter_chat_socketio/controllers/contact_controller.dart';
import 'package:flutter_chat_socketio/controllers/sign_in_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  var messages = <dynamic>[].obs;
  late IO.Socket socket;
  var isConnected = false.obs;
  var isLoading = true.obs;
  var userId = 0.obs;
  var nameUser = ''.obs;
  var conversationId = 0.obs;
  var currentUserId = 0.obs;

  final ContactController contactController = Get.put(ContactController());
  final SignInController signInController = Get.put(SignInController());

  @override
  void onInit() {
    super.onInit();
    userId.value = int.tryParse(Get.parameters['userId'] ?? '0') ?? 0;
    getConversationId();
    connectToSocket(signInController.userId.value, userId.value);
    nameUser.value = contactController.contacts
        .firstWhere((element) => element['id'] == userId.value)['name'];
  }

  void getConversationId() async {
    try {
      isLoading(true);
      var body = {
        'user1Id': signInController.userId.value,
        'user2Id': userId.value,
      };
      var response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/conversations'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        conversationId.value = json.decode(response.body)['id'];
        await fetchMessage(conversationId.value);
      }
    } catch (e) {
      print('error getConversationId');
    } finally {
      isLoading(false);
    }
  }

  void connectToSocket(int senderId, int recipientId) {
    socket = IO.io('${dotenv.env['API_URL']}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Socket event handlers
    socket.onConnect((_) {
      isConnected(true);
      if (kDebugMode) {
        print('Connected to WebSocket');
      }
      // Join the room with conversationId
      socket
          .emit('joinRoom', {'senderId': senderId, 'recipientId': recipientId});
    });

    socket.on('message', (data) {
      if (kDebugMode) {
        print('New message received: $data');
      }
      messages.add(data);
    });

    socket.on('video-chat', (data) {
      if (kDebugMode) {
        print('Video chat: $data');
      }
    });

    socket.onDisconnect((_) {
      isConnected(false);
      if (kDebugMode) {
        print('Disconnected from WebSocket');
      }
    });

    socket.onError((error) {
      if (kDebugMode) {
        print('Socket error: $error');
      }
    });

    socket.connect();
  }

  // Send message
  void sendMessage(int senderId, int recipientId, String content) {
    if (socket.connected) {
      socket.emit('message', {
        'senderId': senderId,
        'recipientId': recipientId,
        'content': content,
      });
    }
  }

  Future<void> fetchMessage(int conversationId) async {
    try {
      isLoading(true);
      var response = await http
          .get(Uri.parse('${dotenv.env['API_URL']}/messages/$conversationId'));
      if (response.statusCode == 200) {
        messages.value = json.decode(response.body);
      }
    } finally {
      isLoading(false);
    }
  }

  // Cleanup on controller dispose
  @override
  void onClose() {
    socket.disconnect();
    socket.dispose();
    super.onClose();
  }
}
