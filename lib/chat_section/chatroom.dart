import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:schoolapp/chat_section/search.dart';
import 'package:schoolapp/helper/database.dart';
import 'package:schoolapp/helper/helperfunction.dart';
import 'package:schoolapp/helper/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  String senderUserId;
  String userName;

  Widget chatRoomsList(String senderUserId) {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var userNames = snapshot.data.documents[index].data['names'];
                  var userNumbers =
                      snapshot.data.documents[index].data['users'];
                  var chatRoomId =
                      snapshot.data.documents[index].data["chatRoomId"];
                  String name = userNames.elementAt(
                    userNumbers.indexOf(
                      chatRoomId
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(senderUserId, ""),
                    ),
                  );
                  return ChatRoomsTile(
                    userName: name,
                    chatRoomId:
                        snapshot.data.documents[index].data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    checkCounter();
    super.initState();
  }

  getUserInfogetChats() async {
    userName = await HelperFunctions.getUserNameSharedPreference();
    senderUserId = await HelperFunctions.getUserPhoneNumberSharedPreference();

    DatabaseMethods().getUserChats(senderUserId).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${userName}");
      });
    });
  }

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String devtoken;
  getDevToken() {
    firebaseMessaging.getToken().then((token) async {
      devtoken = token;

      String phnNumber =
          await HelperFunctions.getUserPhoneNumberSharedPreference();
      Firestore.instance.collection('devtokens').document(phnNumber).setData({
        'devtoken': devtoken.toString(),
      });
    });
  }

  checkCounter() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('counter') == null) {
      await prefs.setInt('counter', 1);

      getDevToken();
    }
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
            title: Text("Chats"),
            actions: [],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: chatRoomsList(senderUserId),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF7f74a4),
        child: Icon(Icons.message),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String chatRoomId;
  final String userName;

  ChatRoomsTile({
    @required this.chatRoomId,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          chatRoomId: chatRoomId,
                          chatUsername: userName,
                        )));
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: CustomTheme.lightBlue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(userName.substring(0, 1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(userName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: '',
                        fontWeight: FontWeight.w400))
              ],
            ),
          ),
        ),
        Divider(
          height: 3,
          thickness: 2,
          color: Colors.grey[300],
          indent: 10,
          endIndent: 10,
        )
      ],
    );
  }
}
