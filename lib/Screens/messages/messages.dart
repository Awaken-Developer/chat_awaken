import 'dart:async';

import 'package:chat_awaken/BasicWids/sBottomPrompt.dart';
import 'package:chat_awaken/BasicWids/sTextFormField.dart';
import 'package:chat_awaken/Screens/ChatList/chatList.dart';
import 'package:chat_awaken/Screens/ChatList/chatUsers.dart';
import 'package:chat_awaken/Screens/WelcomePage/WelcomeScr.dart';
import 'package:chat_awaken/Screens/messages/myMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_awaken/Screens/database.dart';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';

import '../../main.dart';

class messages extends StatefulWidget {
  String reciever;
    int msgCount  ;
    List<msgHandle> listMsgHandle;
  messages({this.reciever, this.msgCount, this.listMsgHandle});
  messagesState createState() => new messagesState();
}

class messagesState extends State<messages> {
  List<msgHandle> listMsgHandle = List();
  String sender;
  String reciever;
  TextEditingController controller;
  int msgCount  ;

  @override
  void initState() {
    sender = userName;
    reciever = widget.reciever;
    msgCount = widget.msgCount;
    
    listMsgHandle = widget.listMsgHandle;
print(listMsgHandle[0].msg);
    controller = new TextEditingController();
    
    database.pushMessageListner(userId, widget.reciever).listen(onMessageAdded);
  }

  void onMessageAdded(DocumentSnapshot snapshot) {
    setState(() {
      listMsgHandle.add(msgHandle.fromJson(snapshot.data()['msg']));
    });
  }

//refresher
  void refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    database.pushCount(sender, reciever, msgCount);
    controller.dispose();
    super.dispose();
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 80.0,
        maxHeight: 120.0,
        child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    offset: Offset(0, 2),
                    blurRadius: 9.0,
                    spreadRadius: 9.0,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                gradient: LinearGradient(
                    colors: [Color(0xFFece9e6), Color(0xFFffffff)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
            child: Row(
              children: [
                IconButton(
                    onPressed: () =>
                        Navigator.of(context).pop(msgRoute(reciever)),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff94aad6),
                    )),
                SizedBox(width: 20),
                Text(
                  reciever,
                  style: TextStyle(
                    color: Color(0xff94aad6),
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFF3F6),
      body: SafeArea(
        top: false,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff94aad6),
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    makeHeader('Messages'),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              messageLook(msghandle: listMsgHandle[index]),
                          childCount: listMsgHandle.length),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: Container(
                  height: 41,
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
                    ],
                  ),
                  child: TextFormField(
                    autofocus: false,
                    controller: controller,
                    //onSaved: widget.saved,
                    //controller: widget.controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 9),
                      suffixIcon: IconButton(
                        onPressed: () => {
                          //msgCount++, correct this
                          database.pushMessage(
                              sender,
                              reciever,
                              msgHandle.ListAdd(
                                  msg: controller.text,
                                  stamp: DateTime.now(),
                                  handleType: HandleType.sended.toString())),
                          controller.clear()
                        },
                        icon: Icon(
                          Icons.send,
                          color: Color(0xff94aad6),
                        ),
                      ),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class messageLook extends StatefulWidget {
  msgHandle msghandle;
  Function action;
  messageLook({this.msghandle, this.action});

  messageLookState createState() => new messageLookState();
}

class messageLookState extends State<messageLook> {
  bool pressed = false;
  void refresh() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    double opacity = 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xff94aad6),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: 
                         Color(0xff7e91b6)
                          ,
                      offset: Offset(
                        5,
                        5,
                      ),
                    ),
                    BoxShadow(
                      blurRadius: 10,
                      color: !pressed
                          ? Color(0xffaac4f6)
                          : Color(0xff7e91b6).withOpacity(opacity),
                      offset: Offset(
                        -5,
                        -5,
                      ),
                    ),
                  ],
                  gradient: LinearGradient(
                    stops: [0, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      !pressed
                          ? Color(0xff9eb6e5)
                          : Color(0xff8599c1).withOpacity(opacity),
                      !pressed
                          ? Color(0xff8599c1)
                          : Color(0xff9eb6e5).withOpacity(opacity),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(
                    5,
                  ))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'This is telegram message   ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0
                            ),
                          ),
                          TextSpan(
                            text: '3:16 PM',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.check, color: Color(0xFF7ABAF4), size: 16,)
                  ]
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  painter: ChatBubbleTriangle(),
                )
              )
            ]
          ),
    );
  }
}


class ChatBubbleTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Color(0xFF486993);

    var path = Path();
    path.lineTo(-15, 0);
    path.lineTo(0, -15);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class CustomRoute extends PopupRoute {
  CustomRoute({
    @required this.builder,
    @required this.dy,
    this.dismissible = true,
    this.label,
    this.color,
    RouteSettings setting,
  }) : super(settings: setting);

  final WidgetBuilder builder;
  final bool dismissible;
  final String label;
  final Color color;
  double dy;

  @override
  Color get barrierColor => color;

  @override
  bool get barrierDismissible => dismissible;

  @override
  String get barrierLabel => label;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    var begin = Offset(0, dy);
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
