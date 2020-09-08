import 'package:chat_awaken/BasicWids/sCupButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class sCupPicker extends StatefulWidget {
  List items;
  var selectedValue;
  Function action;
  sCupPicker({this.items, this.selectedValue, this.action});

  sCupPickerState createState() => new sCupPickerState();
}

class sCupPickerState extends State<sCupPicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 18),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) {
            print(details.velocity.pixelsPerSecond.dy);
            if (details.velocity.pixelsPerSecond.dy > 400){
              widget.action();
            }
          },
          child: Material(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0XFFEFF3F6),
                borderRadius: BorderRadius.circular(20.0),
              ),
              height: MediaQuery.of(context).size.height * .4,
              width: MediaQuery.of(context).size.width * .9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 45,
                    height: 7,
                    decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xff94aad6),
                    ),
                  ),
                 Container(
                   height: MediaQuery.of(context).size.height * .2,
                   width: MediaQuery.of(context).size.width * .8,

                   child: CupertinoPicker(
                useMagnifier: true,
                magnification: 1,
                backgroundColor: Color(0XFFEFF3F6),
                onSelectedItemChanged: (value) {
                      setState(() {
                        widget.selectedValue = value;
                      });
                },
                itemExtent: 32.0,
                children: [
                      for (int i = 0; i < widget.items.length; i++)
                        Text(widget.items[i]),
                ],
              ),
                 ),
                  
                  CupertinoButton(
                    onPressed: () {
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
    );
  }
}


