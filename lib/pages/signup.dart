import 'package:flutter/material.dart';
import 'package:chatapp/Widgets/widget.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'chat_room.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  final Function toggle;
  Signup(this.toggle);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  AuthMethods authMethods=new AuthMethods();
  DataBaseMethods dataBaseMethods=new DataBaseMethods();
  bool isloading=false;
  final formkey=GlobalKey<FormState>();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  signMeUp(){
    if(formkey.currentState.validate()) {

          setState(() {isloading=true;});

       authMethods.signUpwithEmailAndPassword(_email.text, _password.text).then((value) {

            if(AuthMethods.found==true) {
              Map<String, String>usermap = {
                "email": _email.text,
                "name": _username.text,
              };
              HelperFunctions.saveUserLoggedIN(true);
              HelperFunctions.saveUsername(_username.text);
              HelperFunctions.saveUserEmail(_email.text);
              dataBaseMethods.uploadUserInfo(usermap);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoomsScreen()));
            }
            else
              {
                showDialog(context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(title: Text('Registered failed :( ',
                        style: TextStyle(color: Colors.deepPurple),),
                        content: Text('The username or email isn'+"'"+'t available'),
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
                setState(() {isloading=false;});
              }});
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Create new account'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body:isloading?Container(child:Center(child: CircularProgressIndicator()) ,): Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            Form(key: formkey,child: Column(
              children: [
                TextFormField(validator: (val){
                  return val.isEmpty||val.length<2 ? 'Please provide a valid the Username':null;
                },controller: _username,style: simpleTextFieldStyle(),
                  decoration:textfield("Username"),),
                TextFormField(validator: (val){
                  return RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})").hasMatch(val)?null:'Please provide a valid the email';
                },controller: _email,style: simpleTextFieldStyle(),
                    decoration:textfield("Email")),
                TextFormField(obscureText: true,validator: (val){
                  return val.length<6 ? 'The password must be larger than 6 characters':null;
                },controller: _password,style: simpleTextFieldStyle(),
                    decoration:textfield("Password")),
              ],
            ),),
            SizedBox(height: 8,),
            Container(child: RaisedButton(child:Text('Signup'),onPressed: (){
              signMeUp();
            },
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)) ,),),
            Container(child: RaisedButton(child:Text('Sign up with Google'),onPressed: (){
            },
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)) ,),),
            SizedBox(height: 8,),
            GestureDetector(onTap: (){
              widget.toggle();
            },
              child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text("Already have account? ",style: mediumTextStyle(),),
                Text("SignIn Now",style: TextStyle(color: Colors.white,fontSize:16,decoration:TextDecoration.underline ),),
              ],),
            )
          ],),),
        ),
      ) ,
    );
  }
}
