import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class chatUsers {

  String firstName, lastName;
  chatUsers();

  chatUsers.ListAdd({this.firstName, this.lastName});
  Map<String,dynamic> toJson()=><String,dynamic>{
    'firstName' : firstName,
    'lastName' : lastName,
  };
  factory chatUsers.fromJson(Map<String,dynamic> json){
     return chatUsers.ListAdd(firstName:json['firstName'], lastName:json['lastName']);
  }

  
}
 Future<List<chatUsers>> fetchUserList() async {
  final http.Response response = await http.get(
    "https://chatawaken.firebaseio.com/user/chatUser/-MG7cc_ecj-VuRnq3MKK.json");
List<chatUsers> users = new List();
  if (response.statusCode == 200) {
    print(response.statusCode);

    users = (json.decode(response.body)).map((i) => chatUsers.fromJson(i)).toList();
        print(users.length);
    return users;
  } else {
    throw Exception('Failed to fetch.');
  }
}

Future <List<chatUsers>> addUserList(List<chatUsers> listChatUsers) async{
  

final http.Response response = await http.post("https://chatawaken.firebaseio.com/user/chatUser.json",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },

    body: jsonEncode(listChatUsers),
  );
  if (response.statusCode == 200) {
    print(response.statusCode);
print(response.body);
Map<String, dynamic> map = json.decode(response.body);
List<chatUsers> users = (map['name']).map((i) => chatUsers.fromJson(i)).toList();

print(users[1]);
  return users;
  
  } else {
    throw Exception('Failed to fetch.');
  }

}
