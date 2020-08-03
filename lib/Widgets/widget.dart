import 'package:flutter/material.dart';

InputDecoration textfield(String hint)
{
  return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));

}

TextStyle simpleTextFieldStyle(){
  return TextStyle(color: Colors.deepPurpleAccent,fontSize:16);
}

TextStyle mediumTextStyle(){
  return TextStyle(color: Colors.white,fontSize:16);
}