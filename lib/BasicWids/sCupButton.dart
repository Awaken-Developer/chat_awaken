import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class sCupButton extends StatefulWidget {
  //buttonAction
  Function Action;

  //button attributes
  String buttonText;
  Color color;

  sCupButton({Key key, @required this.Action, this.buttonText, this.color});

  sCupButtonState createState() => new sCupButtonState();
}

class sCupButtonState extends State<sCupButton> {
  //Widget
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.transparent,
      onPressed: widget.Action,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27.0)),
      padding: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(color: Color(0xff94aad6),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Color(0xff8599c1),
              offset: Offset(
                10,
                10,
              ),
            ),
            BoxShadow(
              blurRadius: 20,
              color: Color(0xffa3bbeb),
              offset: Offset(
                -10,
                -10,
              ),
            ),
          ],
          gradient: LinearGradient(
            stops: [0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
            Color(0xFFece9e6), Color(0xFFffffff)
              
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(
            27,
          ))),
        constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
        alignment: Alignment.center,
        child: Text(
          widget.buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15,
              color: Color(0xff94aad6),
          ),
        ),
      ),
    );
  }
}
