import 'package:flutter/material.dart';
import 'package:flutter_chat_socketio/controllers/video_chat_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoChatScreen extends StatelessWidget {
  final VideoChatController videoChatController =
      Get.put(VideoChatController());

  VideoChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GetX's controller

    // Connect to the signaling server
    videoChatController.connect(videoChatController.ipAddress.value);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(videoChatController.clientId.isNotEmpty
              ? videoChatController.clientId.value
              : 'P2P Call Sample');
        }),
        actions: const <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: null,
            tooltip: 'setup',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        if (videoChatController.inCalling.value) {
          return SizedBox(
            width: 200.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: videoChatController.switchCamera,
                  child: const Icon(Icons.switch_camera),
                ),
                FloatingActionButton(
                  onPressed: videoChatController.hangUp,
                  tooltip: 'Hangup',
                  backgroundColor: Colors.pink,
                  child: const Icon(Icons.call_end),
                ),
                FloatingActionButton(
                  onPressed: videoChatController.muteMic,
                  child: const Icon(Icons.mic_off),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
      body: Obx(() {
        if (videoChatController.inCalling.value) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.black54),
                      child: RTCVideoView(videoChatController.remoteRenderer),
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      decoration: const BoxDecoration(color: Colors.black54),
                      child: RTCVideoView(videoChatController.localRenderer),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return Container(
            color: Colors.yellow,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: videoChatController.textEditingController,
                ),
                ElevatedButton(
                  child: const Text('Call'),
                  onPressed: () {
                    videoChatController.invitePeer(
                      videoChatController.textEditingController.text,
                      false,
                    );
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
