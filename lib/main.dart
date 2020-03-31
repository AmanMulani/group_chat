import 'package:flutter/material.dart';
import 'package:group_chat/screens/login_screen.dart';
import 'package:group_chat/screens/registration_screen.dart';
import 'package:group_chat/screens/chat_screen.dart';
import 'package:group_chat/screens/welcome_screen.dart';

void main() => runApp(GroupChat());

class GroupChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        LoginScreen.id : (context){return LoginScreen();},
        WelcomeScreen.id : (context){return WelcomeScreen();},
        RegistrationScreen.id : (context){return RegistrationScreen();},
        ChatScreen.id : (context){return ChatScreen();},
      },
    );
  }
}
