import 'dart:async';
import 'dart:convert';
import 'package:chatinunii/authScreens/signup.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/screens/messages/messages_screen.dart';
import 'package:flutter/material.dart';
import '../../../authScreens/login.dart';
import '../../../constants.dart';
import '../../../models/ChatMessage.dart';
import '../../splashscreen.dart';
import 'message.dart';

class Body extends StatefulWidget {
  // final messagelist;
  final username;
  var data;
  int index;
  bool transFlag;
  Body(
      {Key? key,
      required this.username,
      required this.data,
      required this.index,
      required this.transFlag})
      : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

String? langCode;

class _BodyState extends State<Body> {
  @override
  var msgList;
  Timer? timer;

  void initState() {
    // TODO: implement initState
    if (widget.data['IsChatTranslated'] == 0) {
      setState(() {
        transFlag = false;
      });
    } else {
      setState(() {
        transFlag = true;
      });
    }
    super.initState();
    print(socket.connected);
    socket.on('Message', (data) {
      print('socket ${data.toString()}');
    });
    print(widget.data['ChatId']);
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  readmsg() async {
    var readmsg = {
      "ChatId": widget.data['ChatId'],
      "ChatCreatedUserName": widget.username
    };
    socket.emit('ReadChatMessage', readmsg);
  }

  @override
  Widget build(BuildContext context) {
    bool? flag;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
        ),
        child: StreamBuilder<List>(
          stream:
              // widget.transFlag == false
              //     ? Apis().getGetChat(widget.username)
              //     :
              Apis().getTranslatedChat(widget.data['ChatId'],
                  langCode == null ? lang : langCode, token!),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text('Empty Chat'),
              );
            } else {
              print('Trans flag ${widget.transFlag}');
              return SingleChildScrollView(
                  reverse: true,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        readmsg();
                        return Message(
                          message: ChatMessage(
                              text: snapshot.data![index]['Message'],
                              messageType: ChatMessageType.text,
                              messageStatus: MessageStatus.viewed,
                              isSender: snapshot.data![index]['ToUserName'] ==
                                      widget.username
                                  ? true
                                  : false),
                          image: widget.data['ProfilePhotos'] == null
                              ? 'https://chatinuni.com/assets/image/profile-place-holder.jpg'
                              : widget.data['ProfilePhotos'][0]['FileURL'],
                        );
                      }));
            }
          },
        ),
      ),
    );
  }
}
