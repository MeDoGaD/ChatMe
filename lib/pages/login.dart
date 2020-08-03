import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/pages/signup.dart';
import 'package:chatapp/Widgets/widget.dart';
import 'package:flutter/services.dart';
import 'chat_room.dart';


class Login extends StatefulWidget{
  final Function toggle;
  Login(this.toggle);


  @override
  _loginState createState()=>_loginState();
}
class _loginState extends State<Login>{
 TextEditingController _password=new TextEditingController();
 TextEditingController _useremail=new TextEditingController();
 AuthMethods authMethods=new AuthMethods();
DataBaseMethods dataBaseMethods=new DataBaseMethods();
 bool isloading=false;
 QuerySnapshot snapshotUserInfo;
 signIn()
 {
   HelperFunctions.saveUserEmail(_useremail.text);
   HelperFunctions.saveUserLoggedIN(true);
   dataBaseMethods.getUserByUseremail(_useremail.text).then((val){
     snapshotUserInfo=val;
     HelperFunctions.saveUsername(snapshotUserInfo.documents[0].data["name"]);
   });
   setState(() {
    isloading=true;
  });
   authMethods.signInWithEmailAndPassword(_useremail.text, _password.text).then((value){
     if(value!=null){
       Navigator.pushReplacement(context, MaterialPageRoute(
           builder: (context)=>ChatRoomsScreen()));
     }
     else
       {
         showDialog(context: context,
             builder: (BuildContext context) {
               return AlertDialog(title: Text('Login failed :( ',
                 style: TextStyle(color: Colors.deepPurple),),
                 content: Text('The username or password isn'+"'"+'t correct'),
                 actions: <Widget>[
                   FlatButton(child: Text('Ok',
                     style: TextStyle(
                         color: Colors.deepPurple),),
                       onPressed: () {
                         HapticFeedback.vibrate();
                         Navigator.of(context).pop();
                       }),
                 ],);
             });
       }
   });
 }

 @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,appBar: AppBar(title: Text('Login'),backgroundColor: Colors.deepPurpleAccent,),
      body:Center(
        child: SingleChildScrollView(
          child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            TextField(controller: _useremail,style: simpleTextFieldStyle(),
              decoration:textfield("Email"),),
            TextField(controller: _password,style: simpleTextFieldStyle(),obscureText: true,
              decoration:textfield("Password")),
            SizedBox(height: 8,),
           Container(alignment: Alignment.centerRight,child:  Container(padding: EdgeInsets.symmetric(horizontal:16,vertical: 8),
             child: Text("Forget Password?",style: simpleTextFieldStyle(),),),),
            SizedBox(height: 8,),
            Container(child: RaisedButton(child:Text('Login'),onPressed: (){
              signIn();
            },
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)) ,),),
            Container(child: RaisedButton(child:Text('Sign in with Google'),onPressed: (){
            },
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)) ,),),
            SizedBox(height: 8,),
           GestureDetector(onTap: (){
             widget.toggle();
           },
             child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
               Text("Don't have account? ",style: mediumTextStyle(),),
               Text("Register Now",style: TextStyle(color: Colors.white,fontSize:16,decoration:TextDecoration.underline ),),

             ],),
           )
          ],),),
        ),
      ) ,);
  }
}