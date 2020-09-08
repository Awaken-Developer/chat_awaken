import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AwakenLoadingScreen extends StatelessWidget{

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
            image: AssetImage('images/Awakenlogo.png'),
            alignment: Alignment.center ,
          ),
      )
    );
  }
}