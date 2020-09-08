import 'package:chat_awaken/AwakenLoadingScreen.dart';
import 'package:chat_awaken/Screens/WelcomePage/WelcomeScr.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Screens/database.dart';



void main() {
  runApp(MyApp());
}


FirebaseApp app ;
final MyDatabase database = MyDatabase();
String userName;

class MyApp extends StatelessWidget {

Stream<int> flag = (() async* {
    await Future<void>.delayed(Duration(seconds: 1));
    yield 1;
  })();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: flag,
      builder: (context, snapshot) {
        if(snapshot.hasData){
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              // Initialize FlutterFire
              future: Firebase.initializeApp(name: 'ChatAwaken'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  app = snapshot.data;
                  return WelcomeScr();
                }
                return AwakenLoadingScreen();
              }),
        );}
        
        return MaterialApp(home: AwakenLoadingScreen());
      }
    );
  }
}

