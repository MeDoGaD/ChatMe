import 'package:chatapp/pages/chat_room.dart';
import 'package:chatapp/pages/conversation.dart';
import 'package:chatapp/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/login.dart';
import 'package:chatapp/helper/authentication.dart';
import 'package:chatapp/helper/helperfunctions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn=false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
  getLoggedInState()async{
    await HelperFunctions.getUserLoggedIN().then((value) {
      setState(() {
        isLoggedIn=value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
  if(isLoggedIn==null)
    {
      return MaterialApp(
        home: Authenticate(),
      );
    }
  else {
    return MaterialApp(
      home: isLoggedIn ? ChatRoomsScreen() : Authenticate(),
    );
  }

  }
}

