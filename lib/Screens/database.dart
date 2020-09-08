import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:chat_awaken/Screens/ChatList/chatUsers.dart';
import 'package:chat_awaken/Screens/WelcomePage/myUser.dart';

import 'messages/myMessage.dart';

class MyDatabase {
  final databaseReference = FirebaseFirestore.instance;
  final String today = "Y" +
      DateTime.now().year.toString() +
      "M" +
      DateTime.now().month.toString() +
      "D" +
      DateTime.now().day.toString();

  void pushUserBioData(String uid, myUser user) async {
    await databaseReference
        .collection("users")
        .doc(user.firstName.value + user.lastName.value)
        .collection("bio")
        .add(user.toJson());
    await databaseReference
        .collection("users")
        .doc("userList")
        .collection("userIdandName")
        .doc(uid)
        .set({
      'name': user.firstName.value + user.lastName.value,
      'userId': uid
    });
  }

  Future<MyReciever> getUser(String uid) async {
    MyReciever recieved;
    await databaseReference
        .collection("users")
        .doc("userList")
        .collection("userIdandName")
        .where('userId', isEqualTo: uid)
        .get()
        .then(
            (snapshot) => snapshot.docs.forEach((element) {
                  recieved = MyReciever.fromJson(element.data());
                }),
            onError: (error) => throw ('exception'));
    return recieved;
  }

  void pushConversation(String userName, chatUsers user) async {
    await databaseReference
        .collection("users")
        .doc(userName)
        .collection("chats")
        .doc("${user.firstName}${user.lastName}")
        .set(user.toJson());
  }

  Future<List<chatUsers>> fetchList(String userName) async {
    List<chatUsers> listChatUsers = new List<chatUsers>();
    await databaseReference
        .collection("users")
        .doc(userName)
        .collection("chats")
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {listChatUsers.add(chatUsers.fromJson(element.data())); }));
         return listChatUsers;
  }

  Stream<QuerySnapshot> pushConversationListner(String userName) {
    return databaseReference
        .collection("users")
        .doc(userName)
        .collection("chats")
        .snapshots();
  }

  void pushCount(String sender, String reciever, int count ) async{
    await databaseReference
        .collection("users")
        .doc(sender)
        .collection("chats")
        .doc(reciever)
        .set({'msgCount': count}, SetOptions(merge: true));
  }


Future<int> getCount(String sender, String reciever) async {
  int msgCount;
   await databaseReference
        .collection("users")
        .doc(sender)
        .collection("chats")
        .doc(reciever)
        .get()
        .then((snapshot)=>  msgCount = snapshot.get('msgCount') as int );
         print(msgCount);
         return msgCount;
}

  void pushMessage(String sender, String reciever, msgHandle msg) async {
    await databaseReference
        .collection("users")
        .doc(sender)
        .collection("chats")
        .doc(reciever)
        .collection("chat_by_days")
        .doc(today)
        .set({'msg': msg.toJson()}, SetOptions(merge: true));
  }


 Future<List<msgHandle>> fetchMessages(String sender, String reciever) async {
   List<msgHandle> listMsgHandle = new List<msgHandle>();

    await databaseReference
        .collection("users")
        .doc(sender)
        .collection("chats")
        .doc(reciever)
        .collection("chat_by_days")
        .doc(today)
        .get()
        .then((snapshot)  {listMsgHandle.add(msgHandle.fromJson(snapshot.get('msg')));} );
        print(listMsgHandle.toString());

        return listMsgHandle;
        
           
            
  }

  Stream<DocumentSnapshot> pushMessageListner(String sender, String reciever) {
    return databaseReference
        .collection("users")
        .doc(sender)
        .collection("chats")
        .doc(reciever)
        .snapshots();
  }
}

class MyReciever {
  String name;
  String userId;

  MyReciever.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userId = json['userId'];
  }
}
