import 'package:firebase_database/firebase_database.dart';

enum HandleType { sended, recieved  
}

class msgHandle {

  String msg;
  DateTime stamp;
  String handleType;
  msgHandle();

  msgHandle.ListAdd({this.msg, this.stamp, this.handleType});
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': msg,
        'stamp': stamp,
        'handleType': handleType
      };

  factory msgHandle.fromJson(Map<String, dynamic> json) {
    return msgHandle.ListAdd(
        msg: json['message'],
        stamp: json['stamp'].toDate(),
        handleType: json['handleType']  );
  }
}
