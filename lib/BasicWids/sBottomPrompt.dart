import 'package:chat_awaken/Screens/ChatList/chatUsers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_awaken/main.dart';

class sBottomPrompt extends StatefulWidget {
  List items;
  var selectedValue;
  Function action;
  sBottomPrompt({
    this.items,
    this.selectedValue,
    this.action,
  });

  sBottomPromptState createState() => new sBottomPromptState();
}

class sBottomPromptState extends State<sBottomPrompt> {
  final _formKey = new GlobalKey<FormState>();
  chatUsers user = new chatUsers();

  TextEditingController controller1, controller2;
Alignment _dragAlignment = Alignment.bottomCenter;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * .9;
     var height = MediaQuery.of(context).size.height * .4;
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 18),
      child: Align(
        alignment: _dragAlignment,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
      setState(() {
        _dragAlignment += Alignment(
          details.delta.dx / (MediaQuery.of(context).size.width * .45),
          details.delta.dy / (MediaQuery.of(context).size.height * .2),
        );
        width/=details.delta.dy;
        height/=2;
      });
      },
      onVerticalDragCancel: () {
        setState(() {
          _dragAlignment = Alignment.bottomCenter;
        });
      },
          onVerticalDragEnd: (details) {
            print(details.velocity.pixelsPerSecond.dy);
            if (details.velocity.pixelsPerSecond.dy > 700 ||_dragAlignment.y> 1.3) {
              widget.action();
            }
            else
            { setState(() {
          _dragAlignment = Alignment.bottomCenter;
        });
        

            }
          },
          child: Material(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: AnimatedContainer(
              
              decoration: BoxDecoration(
                color: Color(0XFFEFF3F6),
                borderRadius: BorderRadius.circular(20.0),
              ),
              height: height,
              width: width,
              duration: Duration(seconds: 1),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: Container(
                      width: 45,
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xff94aad6),
                      ),
                    )),
                    Text(
                      "Add User",
                      style: TextStyle(color: Color(0xff94aad6)),
                    ),
                    textField2(
                      controller: controller1,
                      label: "First Name",
                      saved: (text) => this.user.firstName = text,
                    ),
                    textField2(
                      controller: controller2,
                      label: "Last Name",
                      saved: (text) => this.user.lastName = text,
                    ),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          _formKey.currentState.save();
                          if (this.user.lastName.isNotEmpty ||
                              this.user.firstName.isNotEmpty)
                            database.pushConversation(userName, this.user);
                        });
                        widget.action();
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(color: Color(0xff94aad6)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class textField2 extends StatefulWidget {
  TextEditingController controller;
  String label;
  Function saved;
  textField2({this.controller, this.label, this.saved});
  textField2State createState() => new textField2State();
}

class textField2State extends State<textField2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFEFF3F6),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(6, 2),
              blurRadius: 6.0,
              spreadRadius: 3.0,
            ),
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.9),
              offset: Offset(-6, -2),
              blurRadius: 6.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: TextFormField(
          autofocus: false,
          onSaved: widget.saved,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 9),
            isDense: true,
            border: InputBorder.none,
            labelText: widget.label,
            labelStyle: TextStyle(color: Color(0xff94aad6)),
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

