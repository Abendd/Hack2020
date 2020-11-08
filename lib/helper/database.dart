import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolapp/helper/helperfunction.dart';

class DatabaseMethods {
  Future<void> addUserInfo(String name, String phoneNumber, String code) async {
    Firestore.instance
        .collection("users")
        .where('userPhoneNumber', isEqualTo: code + phoneNumber)
        .getDocuments()
        .then((value) {
      if (value.documents.length == 0) {
        Firestore.instance.collection("users").add({
          'userName': name,
          'userPhoneNumber': code + phoneNumber,
          'code': code,
          'pwd': 0,
          'photo': 'url'
        }).then((value) {
          HelperFunctions.saveUserIdSharedPreference(value.documentID);
        });
      } else {
        HelperFunctions.saveUserIdSharedPreference(
            value.documents.elementAt(0).documentID);
      }
    });
  }

  getUserInfo(String phoneNumber) async {
    return Firestore.instance
        .collection("users")
        .where("userPhoneNumber", isEqualTo: phoneNumber)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByPhoneNumber(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userPhoneNumber', isEqualTo: searchField)
        .getDocuments();
  }

  Future<bool> addChatRoom(chatRoom, String chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyNumber) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyNumber)
        .snapshots();
  }
}
