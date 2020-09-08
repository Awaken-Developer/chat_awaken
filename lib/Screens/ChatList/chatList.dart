import 'dart:async';

import 'package:chat_awaken/BasicWids/sBottomPrompt.dart';
import 'package:chat_awaken/Screens/ChatList/chatUsers.dart';
import 'package:chat_awaken/Screens/messages/messages.dart';
import 'package:chat_awaken/Screens/messages/myMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_awaken/Screens/database.dart';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';

import '../../main.dart';

class chatList extends StatefulWidget {
  List<chatUsers> listChatUser;
  chatList({this.listChatUser});
  chatListState createState() => new chatListState();
}

class chatListState extends State<chatList> {
  bool prompt = false;
  List<chatUsers> listChatUser = List();

  @override
  void initState() {
    database
        .pushConversationListner(userName)
        .listen((event) => event.docChanges.forEach((element) {
              if (element.type == DocumentChangeType.added) {
                onChatAdded(element.doc.data(), listChatUser);
              }
            }));
    super.initState();
    listChatUser = this.widget.listChatUser;
  }

  void onChatAdded(Map<String, dynamic> chat, List<chatUsers> listChatUser) {
    setState(() {
      listChatUser.add(chatUsers.fromJson(chat));
    });
  }

//refresher
  void refresh() {
    setState(() {});
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
                //Icon(Icons.arrow_back_ios, color: Color(0xff94aad6),),
                SizedBox(width: 20),
                Text(
                  "Chats",
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
        body: SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff94aad6),
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                makeHeader('Chats'),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => userLook(user: listChatUser[index]),
                      childCount: listChatUser.length),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          icon: Icon(
            Icons.add,
            color: Color(0xff94aad6),
          ),
          backgroundColor: Colors.white,
          label: Hero(
            tag: 'adduser',
            transitionOnUserGestures: true,
            child: Text(
              "Add User",
              style: TextStyle(
                color: Color(0xff94aad6),
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(myRoute());
          },
        ));
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

class userLook extends StatefulWidget {
  chatUsers user;
  Function action;
  userLook({this.user, this.action});

  userLookState createState() => new userLookState();
}

class userLookState extends State<userLook> {
  bool pressed = false;
  void refresh() {
    setState(() {
      pressed = !pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    double opacity = 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SizedBox(height: 9),
          GestureDetector(
            onTap: () {
              refresh();
            },
            onTapDown: (details) {
              refresh();
              Navigator.of(context)
                  .push(msgRoute(widget.user.firstName + widget.user.lastName));
            },
            onTapCancel: () => refresh(),
            child: Container(
              height: 71,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xff94aad6),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: !pressed
                          ? Color(0xff7e91b6)
                          : Color(0xffaac4f6).withOpacity(opacity),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.user.firstName} ${widget.user.lastName}",
                      style: TextStyle(
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ]),
            ),
          ),
          SizedBox(height: 9),
        ],
      ),
    );
  }
}

Route msgRoute(String reciever) {
  
  Future<int> futureMsgCount = database.getCount(userName, reciever);
  Future<List<msgHandle>> futureListMsgHandle = database.fetchMessages(userName, reciever);

  return CustomRoute2(
    builder: (context) => FutureBuilder(
        future: Future.wait([futureMsgCount, futureListMsgHandle]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
           
            return messages(
              reciever: reciever,
              msgCount: snapshot.data[0],
              listMsgHandle: snapshot.data[1],
            );
          }
          return Scaffold(
            body: Center(
                child: SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff94aad6),
              ),
              width: 40,
              height: 40,
            )),
          );
        }),
    dismissible: true,
  );
}

Route myRoute() {
  return CustomRoute1(
      builder: (context) => sBottomPrompt(
            action: () => Navigator.of(context).pop(myRoute()),
          ),
      dismissible: true,
      dy: 1);
}

class CustomRoute1 extends PopupRoute {
  CustomRoute1({
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

class CustomRoute2 extends PopupRoute {
  CustomRoute2({
    @required this.builder,
    this.dismissible = true,
    this.label,
    this.color,
    RouteSettings setting,
  }) : super(settings: setting);

  final WidgetBuilder builder;
  final bool dismissible;
  final String label;
  final Color color;

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
    var begin = Offset(1, 0);
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
