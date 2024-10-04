import 'package:flutter/material.dart';
import 'package:flutter_chat_socketio/utils/signaling.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoChatController extends GetxController {
  var clientId = ''.obs;
  var inCalling = false.obs;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  late Signaling _signaling;
  var selfId;
  var ipAddress = '192.168.1.2'.obs;

  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initRenderers();
    // ipAddress.value = Get.parameters['ipAddress'] ?? '';
    // print('IP Address: ${ipAddress.value}');
    connect(ipAddress.value);
  }

  void initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  @override
  void onClose() {
    super.onClose();
    localRenderer.dispose();
    remoteRenderer.dispose();
  }

  void connect(String serverIP) {
    _signaling = Signaling(serverIP)..connect();

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
    _signaling?.bye();
  }

  void switchCamera() {
    _signaling?.switchCamera();
  }

  void muteMic() {
    // Implement mute functionality here
  }
}
