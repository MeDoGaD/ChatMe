import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Conversation_Screen extends StatefulWidget {
  final String ChatRoomID;
  final String username;
  Conversation_Screen(this.ChatRoomID,this.username);
  @override
  _Conversation_ScreenState createState() => _Conversation_ScreenState();
}

class _Conversation_ScreenState extends State<Conversation_Screen> {
  TextEditingController _MsgResult = new TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Stream chatMessageStream;
  ScrollController _scrollController = ScrollController();

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            controller: _scrollController,
                shrinkWrap: true,
                reverse: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
              int len=snapshot.data.documents.length;
                  return MessageTile(
                      snapshot.data.documents[index].data["message"],
                      snapshot.data.documents[index].data["sendby"] ==
                          Constants.myname);
                })
            : Container(
                child: Center(
                  child: Text(
                    "Type you first message here :)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
      },
    );
  }

  sendMsg() {
    if (_MsgResult.text.isNotEmpty) {
      Map<String, dynamic> msgMap = {
        "message": _MsgResult.text,
        "sendby": Constants.myname,
        "time": DateTime.now().millisecondsSinceEpoch.toString()
      };
      dataBaseMethods.addConversationMsgs(widget.ChatRoomID, msgMap);
      _MsgResult.text = "";
    }
  }

  @override
  void initState() {
    dataBaseMethods.getConversationMsgs(widget.ChatRoomID).then((value) {
      setState(() {
        chatMessageStream = value;
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.username),
        backgroundColor: Color(0x54ffffff),
        actions: [
          Icon(Icons.call,color: Colors.blue,),
          SizedBox(width:MediaQuery.of(context).size.width / 18,),
          Icon(Icons.videocam,color: Colors.blue),
          SizedBox(width:MediaQuery.of(context).size.width / 18,),
          Icon(Icons.info,color: Colors.blue),
          SizedBox(width:MediaQuery.of(context).size.width / 18,),

        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: ChatMessageList(),),
            Container(
              //alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54ffffff),
                height: MediaQuery.of(context).size.height / 12,width:MediaQuery.of(context).size.width,
                //padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/20,),
                    Icon(
                      Icons.apps,
                      color: Colors.blue,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/25,),
                    Icon(
                      Icons.add_a_photo,
                      color: Colors.blue,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/25,),
                    Icon(
                      Icons.photo,
                      color: Colors.blue,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/25,),
                    Icon(
                      Icons.mic,
                      color: Colors.blue,
                    ),
                Container(width: MediaQuery.of(context).size.width/4,
                        padding: EdgeInsets.all(9),
                        child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: TextField(
                        controller: _MsgResult,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Message",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      ),
                    )),

                    GestureDetector(
                      onTap: () {
                        HapticFeedback.vibrate();
                        sendMsg();
                      },
                      child: Container(margin: EdgeInsets.only(top: 10,bottom: 10),height: MediaQuery.of(context).size.height / 12,width:MediaQuery.of(context).size.width/9 ,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0x36ffffff),
                              Color(0x0fffffff),
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.only(top: 9,bottom: 9,left: 4,right: 9),
                        child: Image.asset(
                          "assets/send.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/29,),
                    Icon(Icons.insert_emoticon,color: Colors.blue,),
                    SizedBox(width: MediaQuery.of(context).size.width/35,),
                     GestureDetector(onTap: (){
                       _MsgResult.text="❤";
                       sendMsg();
                     },child: Icon(Icons.favorite,color: Colors.blue,)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String msg;
  final bool isSendByMe;
  MessageTile(this.msg, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: isSendByMe?0:24,right:  isSendByMe?24:0),
        margin: EdgeInsets.symmetric(vertical: 8),width:MediaQuery.of(context).size.width ,
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      child:msg!="❤"? Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 24),
        decoration:BoxDecoration(gradient: LinearGradient(
            colors: isSendByMe?[
              const Color(0xff007EF4),
              const Color(0xff2A75BC),
            ] :
            [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF),
            ]),borderRadius:isSendByMe?
        BorderRadius.only(topLeft: Radius.circular(23),bottomLeft: Radius.circular(23),topRight:Radius.circular(23)) :
            BorderRadius.only(topLeft: Radius.circular(23),bottomRight: Radius.circular(23),topRight:Radius.circular(23))),
        child: Text(
          msg,
          style: TextStyle(color: Colors.white, fontSize:17),
        ),

    ):Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize:37),
      ),);
  }
}
