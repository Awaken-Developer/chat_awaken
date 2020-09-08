import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class sTextFormField extends StatefulWidget {
  FocusNode focusNode;
  Function fieldSideIconAction, onSubmitted;
  Function validator;
  String hintString, labelString, shadow;
  Function savedString;
  bool obscure, autofocus;
  TextEditingController controller = new TextEditingController();
  Icon suffixIcon, prefixIcon;
  double width, height;
 double padH, padV;
  TextCapitalization textCap;


  sTextFormField(
      {Key key,
      this.validator,
      this.hintString,
      this.savedString,
      this.controller,
      this.labelString,
      this.suffixIcon,
      this.prefixIcon,
      this.shadow,
      this.obscure,
      this.focusNode,
      this.autofocus,
      this.fieldSideIconAction,
      this.width,
      this.height,
      this.onSubmitted,
      this.textCap,
      this.padH,
      this.padV});

//create state
  sTextFormFieldState createState() => new sTextFormFieldState();
}

class sTextFormFieldState extends State<sTextFormField> {
//defining widget variables

//final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color(0xff94aad6),
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
              Color(0xff8599c1).withOpacity(.5),
              Color(0xff9eb6e5).withOpacity(.6)
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(
            27,
          ))),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: widget.padH ??0,vertical: widget.padV??0 ),
        child: TextFormField(
          focusNode: widget.focusNode,
         style: TextStyle(color: Colors.white60),
          obscureText: widget.obscure,
          validator: widget.validator,
          onSaved: widget.savedString,
          onFieldSubmitted: widget.onSubmitted,
          autovalidate: true,
          textCapitalization: widget.textCap,
          //$$$$$$$$$$$$$$$$$#@@@@@@@@@
          //onFieldSubmitted: R(text){sTextFormField.savedString = text;print(sTextFormField.savedString);},//added
          autofocus: widget.autofocus,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: widget.height ?? 5, horizontal: 18),
            isDense: true,
            border: InputBorder.none,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    onPressed: widget.fieldSideIconAction,
                    icon: widget.suffixIcon,
                  )
                : widget.suffixIcon,
            hintText: widget.hintString,
            labelText: widget.labelString,
            labelStyle: TextStyle(
              color: Colors.white60,
            ),
            prefixIcon: widget.prefixIcon,
          ),
        ),
      ),
    );
  }
}
