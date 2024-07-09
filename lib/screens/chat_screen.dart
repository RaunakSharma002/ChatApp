import 'dart:math';
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText;

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    }catch(e){
      print(e);
    }
  }

  // void getMessages()async{
  //   final messsages = await _firestore.collection('messages').get();
  //   for(var message in messsages.docs){
  //           print(message);
  //   }
  // }

  void messageStream() async{
     await for(var messages in _firestore.collection('messages').snapshots()){
       for(var message in messages.docs){
         print(message);
       }
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)
          ),
        ],
        title: Text("Chat"),
        backgroundColor: Colors.lightBlueAccent,
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessagesStream(),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value){
                        messageText = value;
                        //do something
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                      onPressed: (){
                        messageTextController.clear();
                        //messageText + loggedInnUser.email
                        _firestore.collection("messages").add({
                          "sender": loggedInUser!.email,
                          "text": messageText
                        });
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for(var message in messages){
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          //FOR CHECKING CURRENT USER
          final currentUser = loggedInUser!.email;

          final messageBubble = MessageBubble(sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}



class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});
  final String? sender;
  final String? text;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender!,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe!
                ? BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0))
              : BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)),
            color: isMe! ? Colors.lightBlueAccent : Colors.white,
            // color: Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                text!,
                style: TextStyle(
                    fontSize: 15,
                     color: isMe! ? Colors.white : Colors.black54
                  // color: Colors.black54
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

