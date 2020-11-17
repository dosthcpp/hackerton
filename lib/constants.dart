import 'package:flutter/material.dart';

const kBorderRadiusIfIsMe = BorderRadius.only(
  topLeft: Radius.circular(20.0),
  topRight: Radius.circular(20.0),
  bottomLeft: Radius.circular(20.0),
);

const kBorderRadiusIfIsNotMe = BorderRadius.only(
  topRight: Radius.circular(20.0),
  topLeft: Radius.circular(20.0),
  bottomRight: Radius.circular(20.0),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
    vertical: 5.0,
    horizontal: 10.0,
  ),
  hintText: 'Type your message here...',
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blue,
    )
  )
);

const kMenuTextStyle = TextStyle (
  fontSize: 17.0,
  color: Colors.black54,
);

const kMenuTextStyleHighlighted = TextStyle (
  fontSize: 17.0,
  color: Color(0XFFD292F0),
);

//const kTextFieldDecoration = InputDecoration(
//  hintText: 'Enter a value',
//  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//  border: OutlineInputBorder(
//    borderRadius: BorderRadius.all(Radius.circular(32.0)),
//  ),
//  enabledBorder: OutlineInputBorder(
//    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
//    borderRadius: BorderRadius.all(Radius.circular(32.0)),
//  ),
//  focusedBorder: OutlineInputBorder(
//    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
//    borderRadius: BorderRadius.all(Radius.circular(32.0)),
//  ),
//);
