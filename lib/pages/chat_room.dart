import 'package:chatapp/helper/authentication.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/database.dart';
import 'login.dart';
import 'package:chatapp/pages/conversation.dart';

class ChatRoomsScreen extends StatefulWidget {
  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Stream chatsStream;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  Widget ChatRoomList() {
    return StreamBuilder(
        stream: chatsStream,
        builder: (context, snapshot) {
          return snapshot.hasData? ListView.separated(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return ChatTile(
                    snapshot.data.documents[index].data["ChatRoomID"]
                .toString().replaceAll("_", "").replaceAll(Constants.myname,""),
                    snapshot.data.documents[index].data["ChatRoomID"]);
              },
            separatorBuilder: (BuildContext context, int index) => Divider(height: 1,),
          ):Container(child: Center(child: Text('No contacts have been added yet :(',style: TextStyle(color: Colors.white70),),),);
        });
  }

  getUserInfo() async {
    Constants.myname = await HelperFunctions.getUsername();
    dataBaseMethods.getChatRooms(Constants.myname).then((value) {
      setState(() {
        chatsStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Your Chats'),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body:ChatRoomList() ,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Search()));
          }),

    );
  }
}

class ChatTile extends StatelessWidget {
  final String USername;
  final String ChatRoomid;

  ChatTile(this.USername,this.ChatRoomid);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Conversation_Screen(ChatRoomid,USername)));
    },
      child: Container(color: Colors.white30,padding: EdgeInsets.symmetric(horizontal:24,vertical: 16 ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(
                USername.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              USername,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
