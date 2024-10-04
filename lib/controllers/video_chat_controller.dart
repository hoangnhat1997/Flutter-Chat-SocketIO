import 'package:flutter/material.dart';
import 'package:flutter_chat_socketio/utils/signaling.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoChatController extends GetxController {
  var clientId = ''.obs;
  var inCalling = false.obs;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  late Signaling _signaling;
  // ignore: prefer_typing_uninitialized_variables
  var selfId;
  var ipAddress = ''.obs;

  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    requestPermissions().then((_) {
      initRenderers();
      ipAddress.value = Get.parameters['ipAddress'] ?? '';
      // You can connect after initializing renderers if needed
      // connect(ipAddress.value);
    });
  }

  void initRenderers() async {
    localRenderer = RTCVideoRenderer();
    remoteRenderer = RTCVideoRenderer();
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  @override
  void onClose() {
    super.onClose();
    localRenderer.dispose();
    remoteRenderer.dispose();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void connect(String serverIP) {
    _signaling = Signaling()..connect();

    _signaling.onStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.CallStateNew:
          inCalling.value = true;
          break;
        case SignalingState.CallStateBye:
          localRenderer.srcObject = null;
          remoteRenderer.srcObject = null;
          inCalling.value = false;
          break;
        default:
          break;
      }
    };

    _signaling.onEventUpdate = (event) {
      clientId.value = event['clientId'];
    };

    _signaling.onPeersUpdate = (event) {
      selfId = event['self'];
    };

    _signaling.onLocalStream = (stream) {
      localRenderer.srcObject = stream;
    };

    _signaling.onAddRemoteStream = (stream) {
      remoteRenderer.srcObject = stream;
    };

    _signaling.onRemoveRemoteStream = (stream) {
      remoteRenderer.srcObject = null;
    };
  }

  void invitePeer(String peerId, bool useScreen) {
    if (peerId != selfId) {
      _signaling.invite(peerId, 'video', useScreen);
    }
  }

  void hangUp() {
    _signaling.bye();
  }

  void switchCamera() {
    _signaling.switchCamera();
  }

  void muteMic() {
    // Implement mute functionality here
  }
}
