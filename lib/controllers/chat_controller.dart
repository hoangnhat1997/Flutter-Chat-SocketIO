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

  @override
  void onInit() {
    super.onInit();
    userId.value = int.tryParse(Get.parameters['userId'] ?? '0') ?? 0;
    connectToSocket(userId.value);
    fetchMessage(userId.value);
  }

  // Initialize socket connection
  void connectToSocket(int conversationId) {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Socket event handlers
    socket.onConnect((_) {
      isConnected(true);
      print('Connected to WebSocket');
      socket.emit('joinRoom', conversationId);
    });

    socket.on('message', (data) {
      messages.add(data);
    });

    socket.onDisconnect((_) {
      isConnected(false);
      print('Disconnected from WebSocket');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });

    socket.connect();
  }

  // Send message
  void sendMessage(int senderId, int conversationId, String content) {
    if (socket.connected) {
      socket.emit('message', {
        'senderId': senderId,
        'conversationId': conversationId,
        'content': content,
      });
    }
  }

  void fetchMessage(int userId) async {
    try {
      isLoading(true);
      var response =
          await http.get(Uri.parse('http://localhost:3000/messages/${userId}'));
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
