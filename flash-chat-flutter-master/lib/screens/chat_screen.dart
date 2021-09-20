import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
User loggedUser;
bool isCurrentUser=false;
class ChatScreen extends StatefulWidget {
  static String id='chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgTextController=TextEditingController();
  final _firestore=FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;
  String message;

  void getUser() async{
    try{
    final user=await _auth.currentUser;
    if(user!=null){
      loggedUser=user;
      print(loggedUser.email);
    }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messges').snapshots(),
                // ignore: missing_return
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                    final messages=snapshot.data.docs.reversed;
                    List<msgBubble> msgWid=[];
                    for(var msg in messages){
                      final msgtxt=msg.data()['text'];
                      final msgSender=msg.data()['sender'];
                      final currentUser=loggedUser.email;
                      if(msgSender==currentUser){
                        isCurrentUser=true;
                      }
                      final messageWid=msgBubble(txt: msgtxt,sender: msgSender,isSender: isCurrentUser);
                      msgWid.add(messageWid);
                    }
                    return Expanded(
                        child: ListView(
                          reverse: true,
                          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                          children: msgWid
                        )
                    );

                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      msgTextController.clear();
                      _firestore.collection('messges').add({
                        'text' :message,
                        'sender':loggedUser.email
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class msgBubble extends StatelessWidget {
  final String txt,sender;
  final bool isSender;

  const msgBubble({this.txt, this.sender,this.isSender}) ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isSender?CrossAxisAlignment.start:CrossAxisAlignment.end,
        children:<Widget>[
          Text(sender,style: TextStyle(fontSize: 12.0,color: Colors.black54),),
          Material(
          borderRadius:isSender? BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)):BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)),
          elevation: 5.0,
          color: isSender?Colors.white:Colors.lightBlueAccent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: Text(
              '$txt',
              style: TextStyle(
                color: isSender?Colors.black:Colors.white,
                  fontSize:15.0
              ),
            ),
          ),
        ),]
      ),
    );
  }
}
