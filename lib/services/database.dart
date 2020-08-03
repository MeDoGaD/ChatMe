import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
   UsernameFound(String username)async{
     return await Firestore.instance.collection("Users").where("name",isEqualTo:username).getDocuments();
  }
  UseremailFound(String useremail)async{
    return await Firestore.instance.collection("Users").where("email",isEqualTo:useremail).snapshots();
  }

  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUseremail(String useremail) async {
    return await Firestore.instance
        .collection("Users")
        .where("email", isEqualTo: useremail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("Users").add(userMap);
  }

  createChatRoom(String ChatRoomId, ChatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(ChatRoomId)
        .setData(ChatRoomMap);
  }

  addConversationMsgs(String ChatRoomId, messgaeMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(ChatRoomId)
        .collection("chats")
        .add(messgaeMap);
  }

  getConversationMsgs(String ChatRoomId) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .document(ChatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRooms(String username) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("Users", arrayContains: username)
        .snapshots();
  }
}
