import 'dart:convert';
import 'package:flutter/material.dart';


class myUser {
  myUserAttr firstName, lastName, emailAddress, password, confirmPass, age, gender;
  myUser.formField() {
    firstName = new myUserAttr();
    lastName = new myUserAttr();
    emailAddress = new myUserAttr();
    password = new myUserAttr();
    age = new myUserAttr();
    gender = new myUserAttr();
    confirmPass = new myUserAttr();
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
        'firstName': firstName.value,
        'lastName': lastName.value,
        'emailAddress': emailAddress.value,
        'age': age.value,
        'gender': gender.value
      };

  myUser.fromJson(Map<String, dynamic> json) {
    firstName = new myUserAttr();
    lastName = new myUserAttr();
    emailAddress = new myUserAttr();
    age = new myUserAttr();
    gender = new myUserAttr();
    firstName.value = json['firstName'];
    lastName.value = json['lastName'];
    emailAddress.value = json['emailAddress'];
    age.value = json['age'];
    gender.value = json['gender'];
  }

  
}



class myUserAttr {
  String value;
  TextEditingController controller = new TextEditingController();
  FocusNode focus = new FocusNode();
}


