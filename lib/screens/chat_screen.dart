import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  final _firestore = Firestore.instance;
  String messageText;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          )
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
              stream: _firestore.collection('messages').orderBy("timestamp",).snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                    ),
                  );
                }
                final messages = snapshot.data.documents.reversed; //reversed is used because in the chat interface the messages appear at the top instead of bottom, therefore reversed is used.
                List<MessageWidget> messagesWidget = [];
                for (var message in messages){
                  final messageText = message.data['text'];
                  final sender = message.data['email'];
                  final currentUser = loggedInUser.email;
                  final messageWidget = MessageWidget(
                    name: sender,
                    message: messageText,
                    isMe: currentUser == sender,
                  );
                  messagesWidget.add(messageWidget);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: messagesWidget,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value){
                        messageText = value;
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: kMessageTextFieldDecoration.copyWith(
                        hintText: 'Type your message here',
                        hintStyle: TextStyle(color: Colors.grey,),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: (){
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'email': loggedInUser.email,
                        'text': messageText,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String name;
  final String message;
  final bool isMe;

  MessageWidget({@required this.name, @required this.message, @required this.isMe});



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$name',
            style: TextStyle(color: Colors.grey,),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 2, horizontal: 0),
            child: Material(
              elevation: 5.0,
              borderRadius: isMe ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              )
              : BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('$message',
                style: TextStyle(color: Colors.white),),
              ),
              color: isMe ? Colors.lightBlueAccent : Colors.blueGrey,
            ),
          ),
        ],

      ),
    );
  }
}
