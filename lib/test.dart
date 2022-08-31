import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  IO.Socket socket = IO.io('https://test-api.chatinuni.com', <String, dynamic>{
    "transports": ["websocket"]
  });
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socket.onConnect((data) {
      print('connected');
      print(socket.connected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('test')),
    );
  }
}
