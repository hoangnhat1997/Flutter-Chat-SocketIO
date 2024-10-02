import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect(String url) {
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
  }

  void joinRoom(int roomId) {
    socket.emit('joinRoom', roomId);
  }

  void sendMessage(Map<String, dynamic> message) {
    socket.emit('message', message);
  }

  void disconnect() {
    socket.disconnect();
  }
}
