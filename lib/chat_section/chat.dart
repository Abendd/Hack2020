import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolapp/helper/database.dart';
import 'package:schoolapp/helper/helperfunction.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String chatUsername;
  Chat({this.chatRoomId, this.chatUsername});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String sendername;
  String sendersId;
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  getName() async {
    String _sendername = await HelperFunctions.getUserNameSharedPreference();
    String _sendersId = await HelperFunctions.getUserIdSharedPreference();
    setState(() {
      sendername = _sendername;
      sendersId = _sendersId;
    });
  }

  Widget chatMessages(String sendersId) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                height: h / 1.19,
                child: ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      print("00000000000");
                      print(snapshot.data.documents.length);
                      print(index);
                      return Column(
                        children: [
                          MessageTile(
                            message: snapshot
                                .data
                                .documents[
                                    snapshot.data.documents.length - 1 - index]
                                .data["message"],
                            sendByMe: sendersId ==
                                snapshot
                                    .data
                                    .documents[snapshot.data.documents.length -
                                        1 -
                                        index]
                                    .data["sendBy"],
                          ),
                          index == 0
                              ? SizedBox(
                                  height: h / 18,
                                )
                              : SizedBox(),
                        ],
                      );
                    }),
              )
            : Container();
      },
    );
  }

  addMessage(String sendersId) {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": sendersId,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        'sentTo': widget.chatRoomId
            .toString()
            .replaceAll("_", "")
            .replaceAll(sendersId, ""),
        'sendername': sendername,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });

    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(h / 15),
        child: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFF8ac1d9),
                  const Color(0xFF7f74a4),
                ],
                begin: const FractionalOffset(0.1, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Text(widget.chatUsername),
          ),
        ),
      ),
      backgroundColor: Colors.white, //chnge to white
      body: Container(
        child: Stack(
          children: [
            chatMessages(sendersId),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: h / 15,
                padding: EdgeInsets.only(left: 15, right: 15),
                color: Colors.grey,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageEditingController,
                      decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage(sendersId);
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/images/send.png",
                            height: 25,
                            width: 25,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              begin: const FractionalOffset(0.5, 1.1),
              end: const FractionalOffset(1.0, 10.1),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
              colors: sendByMe
                  ? [
                      const Color(0xFF8ac1d9),
                      const Color(0xFF7f74a4),
                    ]
                  : [
                      const Color(0xFF7f74a4),
                      const Color(0xFF8ac1d9),
                    ],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
